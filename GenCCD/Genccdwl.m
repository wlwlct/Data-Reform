%Base on the assumpution and my understanding, it is very important to get
%the short wavelength and long wavelength separate, and detect the
%lifetime. Because I think all the prediction we made is based on long
%chain, blue emitter has shorter lifetime, otherwise...how to you explain
%destroy chromophore one by one???

%%%%The cutting point for wavelength need to be manually ajust, will apdate
%%%%in the fluture to make it more friendly...



%% This part could be used to generate wavelength change with exp going on
function [ccdt_wavelength,ccdt]=Genccdwl(A,shift)

x_start=A(1,1);
x_end=A(100,1);
%wavelength=A(1:100,1);

for i=[1 2 5 10 50 60]%50 60
figure
mesh(A(i*100+1:(i+1)*100,2:end))
view([0,0,1])
end


for i=1:100
wavelength(i,1)=i;
end

% PART II: Reorganize the CCD data
[nx,ny] = size(A);  
nt = round(nx/100);  
colsum = zeros(1,26);   
% add up the columns to see which is largest
for j = 2:ny;
    for i = 2501:2600;     % because data with light on begin at the second
                        % CCD opening (rows 1-100 are the dark background)
    colsum(1,j) = colsum(1,j) + A(i,j);
    end
end
[maxcol,jmax]=max(colsum)
% array ccdt will have 100 rows of spectral data at nt times
% where each time is a column

ccdt = zeros(100, nt);

% populate the CCDT matrix from the A matrix

for j = 1:nt;
    for i = 1:100;
        k = i + (j-1)*100;   
        ccdt(i,j) = A(k,jmax);
    end
end


    % PART IIC: Dark background subtraction
    
% use the first CCD image for background subtraction

bkg = 0;

for i = 1:100;
    bkg = bkg + ccdt(i,1);
end

bkgavg = bkg/100.;

ccdt = ccdt - bkgavg;    % subtract the average dark pixel from every point



% PART IID: Remove data glitches (despike ccdt(100,nt)
% Insist that values in the CCD data matrix ccdt do not have
% neighboring pixels with more than 3x the intensity and values
% above the average across the third spectrum (choice of third arbitrary) 
% 
av3 = 0;         % average of the third spectrum 

for i = 1:100;
    av3 = av3 + ccdt(i,30);
end
av3 = av3/100.;
% 
% for j = 1:nt;   % starts at second time since first spectrum is background
%     for i = 1:99;
%         if (ccdt(i,j) > 2*ccdt(i+1,j)) && (ccdt(i,j) > 3*av3);
%             ccdt(i,j) = 0;  % set spike equal to zero
%         end
%     end
% end


[zong,heng]=size(ccdt);


ccdt_min=[];
w=A(1:100,1)+shift;
ccdt_min=min(min(ccdt));
    ccdt=ccdt-ccdt_min;
 mesh(ccdt);   

%If spike show up, stop here and give (y,x); the value should be valuable
%if the number is average between 2 numbers.((y-1)+(y+1))/2
for i=2:heng
 
ccdt_wavelength(i,1)=sum(ccdt(1:zong,i).*w(1:end))/sum(ccdt(1:zong,i));

end
ccdt=cat(2,w,ccdt);

end
%%



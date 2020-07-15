
function [ccdt_wavelength,ccdt]=Genccdwl(A,shift,wavebin)
    x_start=A(1,1);
    x_end=A(wavebin,1);
%Check on same row or not
    for i=[1 2 5 10 50 60]
        figure;
        mesh(A(i*wavebin+1:(i+1)*wavebin,2:end));view([0,0,1])
    end
    
% PART II: Reorganize the CCD data
    [nx,~] = size(A); nt = round(nx/wavebin);      
    colsum=[0 sum(A(2501:2600,2:end),1)];
%%%place for check point to find weather the data row is selected wrong.
    [~,jmax]=max(colsum)
    
% populate the CCDT matrix from the A matrix
%%%place need a check point to determin the measurement...
    ccdt=reshape(sum(A(:,jmax:jmax+1),2),wavebin,[]);
% PART IIC: Dark background subtraction
% use the first CCD image for background subtraction
    bkgavg=sum(ccdt(1:wavebin,1))/wavebin;
    ccdt = ccdt - bkgavg;    % subtract the average dark pixel from every point

% PART IID: Remove data glitches 
    [zong,heng]=size(ccdt);
    ccdt_min=[];
    w=A(1:wavebin,1)+shift;
    ccdt_min=min(min(ccdt));
    ccdt=ccdt-ccdt_min;%a constant baseline is also removed
    mesh(ccdt);   
%%%check point
%If spike show up, stop here and give (y,x); the value should be valuable
%if the number is average between 2 numbers.((y-1)+(y+1))/2
    ccdt_wavelength=zeros(heng-1,1);
    for i=2:heng
        ccdt_wavelength(i,1)=sum(ccdt(1:zong,i).*w(1:end))/sum(ccdt(1:zong,i));
    end
ccdt=cat(2,w,ccdt);

end
%%



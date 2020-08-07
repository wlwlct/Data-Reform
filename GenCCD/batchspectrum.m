%Change shift as needed, check which row used in Genccdwl 
clear all;clc;
fprintf(1,'\n');
codefolder=pwd;
shift=0;%blue or redshift results
wavebin=100;
srcDir='E:\F8Se2 July\08062020\ccd';
cd(srcDir);
allnames=struct2cell(dir('*.asc')); 
[k,len]=size(allnames); 
cd(codefolder)
for ii=1:len
filename=allnames{1,ii};
pathname=allnames{2,ii};
position=[pathname '\' filename];
A=importdata(position);
wavebin=length(unique(A(:,1)));
%%%for super low signal, start detect from front half and end half.
A=A(:,:);
%%%%%%%%%%%%
cd(codefolder)
ccdt_wavelength=[];ccdt=[];
[ccdt_wavelength,ccdt]=Genccdwl(A,shift,wavebin);
cd(srcDir)
ccdt(17,1:5)
subplot(2,1,1)
mesh(1:1:length(ccdt(1,2:end)),ccdt(:,1),ccdt(:,2:end))
view([1 1 1])
subplot(2,1,2)
plot(ccdt_wavelength(2:end))
min(min(ccdt));colormap(jet)
%If know spike location, (y,X+1)=0;
save(strcat('ccdt_wavelength  ',filename(1:length(filename)-4),'.mat'),'ccdt_wavelength');
save(strcat('ccdt  ',filename(1:length(filename)-4),'.mat'),'ccdt')
saveas(gcf,[filename(1:length(filename)-4) '.fig'])
close all
end
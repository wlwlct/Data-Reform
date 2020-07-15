%Change shift as needed, check which row used in Genccdwl 

clear all;
clc;
fprintf(1,'\n');
shift=0;
%srcDir=uigetdir('Choose source directory.'); 
srcDir='E:\02032020\CCD\New folder';
cd(srcDir);
allnames=struct2cell(dir('*.asc')); 
[k,len]=size(allnames); 
cd('C:\Users\Livi\Documents\Results\Matlab code\convert to pt3 dat asc')
for ii=1:len
filename=allnames{1,ii}
pathname=allnames{2,ii};
position=[pathname '\' filename];
A=importdata(position);
%%%for super low signal, start detect from front half and end half.
A=A(:,:);
%%%%%%%%%%%%
cd('C:\Users\Livi\Documents\Results\Matlab code\convert to pt3 dat asc')
ccdt_wavelength=[];ccdt=[];
[ccdt_wavelength,ccdt]=Genccdwl(A,shift);
cd(srcDir)
ccdt(17,1:5)
subplot(2,1,1)
mesh(1:1:length(ccdt(1,2:end)),ccdt(:,1),ccdt(:,2:end))
view([1 1 1])
subplot(2,1,2)
plot(ccdt_wavelength(2:end))
min(min(ccdt))
colormap(jet)
%If know spike location, (y,X+1)=0;
save(strcat('ccdt_wavelength  ',filename(1:length(filename)-4),'.mat'),'ccdt_wavelength');
save(strcat('ccdt  ',filename(1:length(filename)-4),'.mat'),'ccdt')
saveas(gcf,[filename(1:length(filename)-4) '.fig'])
close all
end
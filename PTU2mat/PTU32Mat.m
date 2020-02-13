%filename=[];
clear all;
clc;
pathname=['C:\Users\Livi\Documents\Results\0505convolution\'];
current_folder=pwd;
cd(pathname);
allnames=struct2cell(dir('*.ptu')); 
[~,len]=size(allnames); 
for ii=1:len
    cd(current_folder)
    filename=allnames{1,ii};
%[filename,pathname]=uigetfile('*.ptu', 'T-Mode data:');
try
Resolution=Read_PTU_Mod(filename, pathname);
disp('Finish PTU demo convert')
PTU3file=importdata(strcat(pathname,filename(1:length(filename)-4), '.out'));
disp('Finish load *.out file')
PTU3file=rmfield(PTU3file,'textdata');
%cd(pathname)
%PTU3file=importdata(strcat(pathname,filename(1:length(filename)-4), '.out'),',',1);
%[A,B,C]=importdata(strcat(pathname,filename(1:length(filename)-4), '.out'));
cd(pathname)
save(strcat(filename(1:length(filename)-4),'.mat'),'PTU3file','Resolution')
disp('Finish generate *.mat, it suppose to move to next file...')
clearvars Resolution PTU3file
catch me
    disp(strcat('Something wrong with file',filename));
end
cd(pathname)
end
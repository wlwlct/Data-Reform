%filename=[];
clear all;
clc;
%pathname=['/scratch/lwang74/PTU_spectrum_lifetime_bluhive/PTUdata/01222019/apd/'];
pathname=['/scratch/lwang74/PTU_spectrum_lifetime_bluehive/PTUdata/06252019/apd/'];
current_folder=pwd;
cd(pathname);
allnames=struct2cell(dir('*.ptu')); 
[~,len]=size(allnames); 
for ii=1:len
    cd(current_folder);
disp('Move to program folder')
    filename=allnames{1,ii};
%[filename,pathname]=uigetfile('*.ptu', 'T-Mode data:');
%try
Resolution=Read_PTU_Mod(filename, pathname);
disp('Finish using demo code to convert data to *.out file');
PTU3file=importdata(strcat(pathname,filename(1:length(filename)-4), '.out'));
PTU3file=rmfield(PTU3file,'textdata');
disp('Finish loading *.out file, prepare to transfer to *.mat file');
%cd(pathname)
%PTU3file=importdata(strcat(pathname,filename(1:length(filename)-4), '.out'),',',1);
%[A,B,C]=importdata(strcat(pathname,filename(1:length(filename)-4), '.out'));
cd(pathname);
save(strcat(filename(1:length(filename)-4),'.mat'),'PTU3file','Resolution');
disp('It suppose to finish saving as *.mat file and move to the next!');
clearvars Resolution PTU3file;
%catch me
 %   disp(strcat('Somrthing wrong with file',filename));

%end
end

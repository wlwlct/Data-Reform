%Under the main direction, {'Pathname'},{'Foldername'},{'Match Plot'},
%{'Time Trace'},{'Mesh'}, {'Scatter Plot'}, {'First 1/3'},{'Second 1/3'},
%{'Third 1/3'},{'ccd Add Up'},{'asc strip'}]; is plotted. the origin data is from.
%ccdt file must be put outside the folder. This is generated before
%ggenerate dataset files.

clear all
codefolder=pwd;
%For my file need to change Generalname etc.;
folderlocation='E:\';
cd(folderlocation);
properfolder=dir('02202020 Rerun');
properfolder_leng=length(properfolder);
for properfolder_i=1:1:properfolder_leng
pathname=[properfolder(properfolder_i).folder '\' properfolder(properfolder_i).name];

%Open excel and try to put into proper place
% names=extractfield(files,'name');
% names=reshape(names,[files_leng,1]);
cd(pathname)
files=dir('*ccdt*.mat');
files_leng=length(files);

Ex=actxserver('Excel.Application');
Exwokbook=Ex.Workbooks.Add;
Ex.Visible=1;
Exsheets=Ex.ActiveWorkbook.Sheets;
Firstsheet=Exsheets.get('Item',1);
Firstsheet.Activate
%write in folder names
place=strfind(pathname,'\');
foldername=pathname(place(1,end)+1:length(pathname));
Folderrange=get(Ex.ActiveSheet,'Range',['A2:A' num2str(files_leng+1)]);
Folderrange.Value=foldername;
title=[{'Pathname'},{'Foldername'},{'Match Plot'},{'Time Trace'},{'Mesh'}, {'Scatter Plot'}, {'First 1/3'},{'Second 1/3'},{'Third 1/3'},{'ccd Add Up'},{'asc strip'}];
Titlerange=get(Ex.ActiveSheet,'Range','A1:K1');
Titlerange.Value=title;
dpi = get(groot, 'ScreenPixelsPerInch');  % Get screen dpi
n=0;
for files_i=2:1:files_leng+1
filename=files(files_i-1).name;
pathname=files(files_i-1).folder;
% Generalname=filename(length(filename)-9:length(filename)-4);
regularexp='\d*d\d*d\d*.mat';
T=regexp(filename,regularexp);
Generalname=filename(T:end-4);


%try and catch to load eberything that is possible
ccdtfile=[];
ccdintensity=[];
apdintensity=[];
maxccdintensity=[];
minccdintensity=[];
datfile=[];
ascfile=[];
ascfile_add_up=[];
avewl=[];

try
    ccdtfile=load([pathname '\' filename]);
    ccdtfile=ccdtfile.ccdt;
    upper=length(ccdtfile(1,3:end));
    ccdintensity=sum(ccdtfile(:,3:end),1);
    maxccdintensity=max(ccdintensity);
    minccdintensity=min(ccdintensity);    
catch
    disp('fail load/find CCDT file')
end

try
try
   cd(pathname);
   datname=dir(['**\*' Generalname '.dat']);
   datfile=importdata([datname.folder '\' datname.name]);
   datfile=datfile.data;
   cd(codefolder);
catch
       cd(pathname);
   datname=dir(['apd\*' Generalname '.mat']);
      cd(codefolder);
   [apddata,~]=PTUim([datname.folder '\' datname.name]);
   datasource=GetDandABS(apddata,0,'M');
   datfile=Gen_timetrace(datasource(:,1),0.01*10^9); 
   datfile(:,1)=(datfile(:,1)-min(datfile(:,1)))/10^9;
    end
catch
disp('fail find dat file');
end

 try
    try
    ascfile=importdata([pathname '\' Generalname '.asc']);
    catch
   cd(pathname);
   ascname=dir(['**\*' Generalname '.asc']);
   ascfile=importdata([ascname.folder '\' ascname.name]); 
   cd(codefolder);
    end
    max_i=floor(length(ascfile(:,1))/100);
    ascfileZ=zeros(26,100,max_i);
    for i=0:1:max_i-1 
    ascfileZ(:,:,i+1)=transpose(ascfile(i*100+1:i*100+100,:)); 
    end
    ascfile_add_up=sum(ascfileZ(2:end,:,:),3);
    ascfile_add_up=cat(1,ascfileZ(1,:,1),ascfile_add_up);
 catch
     disp('fail find asc files')
 end
 
%write in file names
Firstsheetrange=get(Ex.Activesheet,'Range',['B' num2str(files_i)]);
Firstsheetrange.Value=filename;
%%
%plot matchplot if possible
if ~isempty(datfile)
segbin=1.07/(datfile(2,1)-datfile(1,1));%integration time over some number
secbin=1/(datfile(2,1)-datfile(1,1));
totalbin=length(datfile(:,1));
notn=floor(totalbin/segbin);
intensity=zeros(notn+1,2);
for n_num=0:1:notn
    if n_num<notn
    apdintensity(n_num+1,1)=sum(datfile(n_num*segbin+1:n_num*segbin+secbin,2))*1000;%counts/sec
    else
        apdintensity(n_num+1,1)=sum(datfile(n_num*segbin:end,2))*1000;%counts/sec
    end
end
figure
    yyaxis left
    plot(apdintensity);
    yyaxis right
    plot(ccdintensity)
    legend('apd','ccd')
else
    figure
    plot(ccdintensity);
end
%save the plot
n=n+1;
print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
% print(gcf,'-clipboard', '-dbitmap');
 pause (0.5);
 Ex.ActiveSheet.Range(['C' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['C' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['C' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);
%%
%plot time trace,if possible
if ~isempty(datfile)
figure
plot(datfile(:,1),datfile(:,2));
xlabel('Exp Time (s)')
ylabel('Intensity (Counts/ms)');
n=n+1;
%save the plot
print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
% print(gcf,'-clipboard', '-dbitmap');
 pause (0.5);
 Ex.ActiveSheet.Range(['D' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['D' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['D' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);
end

%%
%Plot proper ccd mesh file
if ~isempty(ccdtfile)
figure
mesh(1:1:length(ccdtfile(1,3:end)),ccdtfile(:,1),ccdtfile(:,3:end));
view([0 0 1]);
colormap(jet);
n=n+1;

print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
% print(gcf,'-clipboard', '-dbitmap');
 pause (0.5);
Ex.ActiveSheet.Range(['E' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['E' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['E' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);
end
%%
%Plot average intensity, experiment time with average wavelength

ccdtlength=length(ccdtfile(1,3:end));
avewl=zeros(ccdtlength,1);
for ccdt_n=1:1:ccdtlength
    [~,position496]=min(abs(ccdtfile(:,1)-496));
avewl(ccdt_n,1)=sum(ccdtfile(position496:end,ccdt_n+2).*ccdtfile(position496:end,1))/sum(ccdtfile(position496:end,ccdt_n+2));
end
        figure
        yyaxis left
        plot(avewl,ccdintensity,'o');
        ylabel('Intensity');
        yyaxis right
        plot(avewl,1:1:length(avewl),'o');
        ylabel('exp time (s)');
        xlabel('average wavelength after 496 nm (nm)');
        xlim([540 620])
        n=n+1;
        print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
   pause (0.5);
% print(gcf,'-clipboard', '-dbitmap');
Ex.ActiveSheet.Range(['F' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['F' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['F' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);

%%
thirdccdtlength=floor(ccdtlength/3);
%plot 1/3 of the data 1, comapare;
figure
plot(ccdtfile(:,1),sum(ccdtfile(:,3:thirdccdtlength+2),2));
        n=n+1;
        print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
   pause (0.5);
% print(gcf,'-clipboard', '-dbitmap');
Ex.ActiveSheet.Range(['G' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['G' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['G' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);

%%
%plot 1/3 of the data 2
figure
plot(ccdtfile(:,1),sum(ccdtfile(:,thirdccdtlength+3:thirdccdtlength*2+2),2));
        n=n+1;
        print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
   pause (0.5);
% print(gcf,'-clipboard', '-dbitmap');
Ex.ActiveSheet.Range(['H' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['H' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['H' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);

%%
%plo 1/3 of the data 3
figure
plot(ccdtfile(:,1),sum(ccdtfile(:,thirdccdtlength*2+3:end),2));
        n=n+1;
        print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
   pause (0.5);
% print(gcf,'-clipboard', '-dbitmap');
Ex.ActiveSheet.Range(['I' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['I' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['I' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);

%%
%plot ccd add up
if ~isempty(ccdtfile)
figure
plot(ccdtfile(:,1),sum(ccdtfile(:,3:end),2));
n=n+1;

print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
% print(gcf,'-clipboard', '-dbitmap');
 pause (0.5);
Ex.ActiveSheet.Range(['J' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['J' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['J' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);
end

%%
%plot max asc
if ~isempty(ascfile_add_up)
        rowddup=sum(ascfile_add_up(2:end,:),2);
    [~,maxplace]=max(rowddup);
    figure
    plot(ascfile_add_up(1,:),ascfile_add_up(maxplace+1,:));
    n=n+1;

print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
% print(gcf,'-clipboard', '-dbitmap');
 pause (0.5);
Ex.ActiveSheet.Range(['K' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['K' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['K' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);
end

end

%%
SaveAs(Exwokbook,[pathname '\' foldername '.xlsx']);
Close(Exwokbook)
Quit(Ex)
end
%Under the main direction, [apd/ccd int; mesh ccd with int,ave el; mesh newccd with lf; normalized dtime along time.]
%is plotted. the origin data is from dataset.

clearvars; close all;
codefolder=pwd;
%For my file need to change Generalname etc.;
folderlocation='E:\';
cd(folderlocation);
properfolder=dir('*F8T2O2');
properfolder_leng=length(properfolder);
place=22;
for properfolder_i=1:1:properfolder_leng
    pathname=[properfolder(properfolder_i).folder '\' properfolder(properfolder_i).name];
    %Open excel and try to put into proper place
    cd(pathname)
    files=dir('*dataset*.mat');
    files_leng=length(files);

    Ex=actxserver('Excel.Application');
    Exwokbook=Ex.Workbooks.Add;
    Ex.Visible=1;
    Exsheets=Ex.ActiveWorkbook.Sheets;
    Firstsheet=Exsheets.get('Item',1);
    Firstsheet.Activate
    %write in folder names
    p=strfind(pathname,'\');
    foldername=pathname(p(1,end)+1:length(pathname));
    Folderrange=get(Ex.ActiveSheet,'Range',['A2:A' num2str(files_leng+1)]);
    Folderrange.Value=foldername;
    title=[{'Pathname'},{'Foldername'},{'Match Plot'},{'Normalized CCD and AveWl'},{'CCD, Int, Lf'},{'NewCCD, Int, Lf'},{'10 sec normalized'}];
    Titlerange=get(Ex.ActiveSheet,'Range','A1:G1');
    Titlerange.Value=title;
    dpi = get(groot, 'ScreenPixelsPerInch');  % Get screen dpi
    picrange=get(Ex.ActiveSheet,'Range',['B1:G' num2str(files_leng+1)]);
    picrange.ColumnWidth=50;
    picrange.RowHeight=100;

    n=0;
    for files_i=2:1:files_leng+1
        filename=files(files_i-1).name;
        pathname=files(files_i-1).folder;
        regularexp='\d*d\d*d\d*.mat';
        T=regexp(filename,regularexp);
        Generalname=filename(T:end-4);

        %try and catch to load eberything that is possible
        try
            datasetfile=importdata([pathname '\' filename]);
        catch
            disp('fail load/find dataset file')
        end
        %write in file names
        Firstsheetrange=get(Ex.Activesheet,'Range',['B' num2str(files_i)]);
        Firstsheetrange.Value=filename;
%%
%plot matchplot if possible
        try
            figure
            yyaxis left;plot(datasetfile.scatterplot.intensity(1,:));
            yyaxis right;plot(datasetfile.scatterplot.intensity(2,:))
            legend('apd','ccd')
            xlabel('Exp Time (s)')
            ylabel('Intensity (Counts/ms)');
        catch
            disp('No intensity found')
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
%plot CCD spectrum with average wavelength
figure;
surf(1:99,datasetfile.ccdt(place:end,1),normalize(datasetfile.ccdt(place:end,3:end),1,'range'),'EdgeColor','none');
view([0 0 1]);colormap(jet);
hold on; scatter3(1:99,datasetfile.scatterplot.spectrum,1.5*ones(1,99),'r','filled')
xlabel('Exp Time (s)')
ylabel('Wavelength (nm)');
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

%%
%Plot proper ccd mesh with lifetime and intensity
figure
datanum=3;%mesh;ccd intensity/sudchange,lifetiem
colorY=['k','r','m','g','y'];
%mesh first
surf(1:99,datasetfile.ccdt(place:end,1),normalize(datasetfile.ccdt(place:end,3:end),1,'range'),'EdgeColor','none');
view([0 0 1]);colormap(jet);xlabel('Exp Time (s)');ylabel('Wavelength (nm)');

ax(1) = get(gcf,'Children');
pos = get(ax(1),'position');
cfig = get(gcf,'color');

offset=0.07;
startX=offset*datanum;
pos = [startX 0.1 0.95-startX 0.8];
set(ax(1),'position',pos);
limx1 = get(ax(1),'xlim');
%
i=2;poss=[pos(1)-offset*(i-1) pos(2) pos(3)+offset*(i-1) pos(4)];
    scale = poss(3)/pos(3);
    limxs = [limx1(2)-scale*(limx1(2)-limx1(1)) limx1(2)];
    ax(i)=axes('Position',poss,'box','off',...
        'Color','none','XColor',cfig,'YColor',colorY(i),...
        'xtick',[],'xlim',limxs,'yaxislocation','left');
    
 line(1:1:99,datasetfile.scatterplot.intensity(2,:),'Color',colorY(i),'Parent',ax(i),'LineWidth',3);
ylabel('Intensity')

i=3;poss=[pos(1)-offset*(i-1) pos(2) pos(3)+offset*(i-1) pos(4)];
scale = poss(3)/pos(3);
limxs = [limx1(2)-scale*(limx1(2)-limx1(1)) limx1(2)];
ax(i)=axes('Position',poss,'box','off',...
'Color','none','XColor',cfig,'YColor',colorY(i),...
        'xtick',[],'xlim',limxs,'YLim',[50 2500],'yaxislocation','left');
line(1:1:99,datasetfile.scatterplot.lifetime(:,2),'Color',colorY(i),'Parent',ax(i),'LineWidth',3);
ylabel('Lifetime')
yticks([50:400:2500]);

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

%%
%Plot proper new ccd mesh with lifetime and intensity
figure
datanum=3;%mesh;ccd intensity/sudchange,lifetiem
colorY=['k','r','m','g','y'];
%mesh first
surf(1:99,datasetfile.newccdt(place:end,1),normalize(datasetfile.newccdt(place:end,3:end),1,'range'),'EdgeColor','none');
view([0 0 1]);colormap(jet);xlabel('Exp Time (s)');ylabel('Wavelength (nm)');

ax(1) = get(gcf,'Children');
pos = get(ax(1),'position');
cfig = get(gcf,'color');

offset=0.07;
startX=offset*datanum;
pos = [startX 0.1 0.95-startX 0.8];
set(ax(1),'position',pos);
limx1 = get(ax(1),'xlim');
%
i=2;poss=[pos(1)-offset*(i-1) pos(2) pos(3)+offset*(i-1) pos(4)];
    scale = poss(3)/pos(3);
    limxs = [limx1(2)-scale*(limx1(2)-limx1(1)) limx1(2)];
    ax(i)=axes('Position',poss,'box','off',...
        'Color','none','XColor',cfig,'YColor',colorY(i),...
        'xtick',[],'xlim',limxs,'yaxislocation','left');
    
 line(1:1:99,datasetfile.scatterplot.intensity(2,:),'Color',colorY(i),'Parent',ax(i),'LineWidth',3);
ylabel('Intensity')

i=3;poss=[pos(1)-offset*(i-1) pos(2) pos(3)+offset*(i-1) pos(4)];
scale = poss(3)/pos(3);
limxs = [limx1(2)-scale*(limx1(2)-limx1(1)) limx1(2)];
ax(i)=axes('Position',poss,'box','off',...
'Color','none','XColor',cfig,'YColor',colorY(i),...
        'xtick',[],'xlim',limxs,'YLim',[50 2500],'yaxislocation','left');
line(1:1:99,datasetfile.scatterplot.lifetime(:,2),'Color',colorY(i),'Parent',ax(i),'LineWidth',3);
ylabel('Lifetime')
yticks([50:400:2500]);

n=n+1;
print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
% print(gcf,'-clipboard', '-dbitmap');
 pause (0.5);
Ex.ActiveSheet.Range(['F' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['F' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['F' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);


%%
%plot ccd add up
figure
yyaxis left; plot(datasetfile.ccdt(place:end,1),normalize(sum(datasetfile.ccdt(place:end,3:12),2),1,'range'),'LineWidth',3);
yyaxis right; plot(datasetfile.ccdt(place:end,1),normalize(sum(datasetfile.ccdt(place:end,end-9:end),2),1,'range'),'LineWidth',3);
legend('First 10 secs','Last 10 secs')
xlabel('Wavelength (nm)')
ylabel('Normalized Intensity')
n=n+1;
print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
  % print(gcf,'-clipboard', '-dbitmap');
 pause (0.5);
Ex.ActiveSheet.Range(['G' num2str(files_i)]).PasteSpecial();
Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range(['G' num2str(files_i)]).Width;    %Adjusting width
Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range(['G' num2str(files_i)]).Height;  %Adjusting height
Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
close(gcf);
end
%%
SaveAs(Exwokbook,[pathname '\' foldername '.xlsx']);
Close(Exwokbook)
Quit(Ex)
end

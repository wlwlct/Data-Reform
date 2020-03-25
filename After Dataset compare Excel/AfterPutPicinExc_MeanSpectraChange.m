%Under the main direction, [apd/ccd int; mesh ccd with int,ave el; mesh newccd with lf; normalized dtime along time.]
%is plotted. the origin data is from dataset.

clearvars; close all;
codefolder=pwd;
%For my file need to change Generalname etc.;
folderlocation='E:\';
cd(folderlocation);
properfolder=dir('*F8T2400nmCH');
properfolder_leng=length(properfolder);
place=1;
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
    %title=[{'Pathname'},{'Foldername'},{'Match Plot'},{'Normalized CCD and AveWl'},{'CCD, Int, Lf'},{'NewCCD, Int, Lf'},{'10 sec normalized'}];
    title=[{'Pathname'},{'Foldername'},{'Match Plot'},{'State Separate'},{'Spectra Different Range'}];
    Titlerange=get(Ex.ActiveSheet,'Range','A1:E1');
    Titlerange.Value=title;
    dpi = get(groot, 'ScreenPixelsPerInch');  % Get screen dpi
    picrange=get(Ex.ActiveSheet,'Range',['B1:J' num2str(files_leng+1)]);
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
        try
            fit_state=datasetfile.side.potential(2,:);
        catch
            cd(codefolder)
            [~,A.eff_fit,~,A.numst,~]=Traceson(datasetfile.scatterplot.intensity(2,:),codefolder);
            if length(A.eff_fit(:,1))==1;A.numst=1;end
            fit_state=A.eff_fit(A.numst,:);
        end
        change_place=diff(fit_state);
        loc=find(change_place~=0);loc(1,end+1)=99;
        loc=[1,loc(1,1:end-1)+1;loc(1,:)];
        loc=loc(:,loc(1,:)<=loc(2,:));
        F_leng=length(loc(1,:));     
        
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
%plot match potential plot
        try
            figure
            yyaxis left;plot(datasetfile.scatterplot.intensity(2,:))
            hold on;plot(fit_state(1,:),'LineWidth',3)
            hold on;scatter(loc(1,:),fit_state(1,loc(1,:)),100,'filled')
            ylabel('Intensity (Counts/ms)');
            for i=1:F_leng
                text(loc(1,i)-1,fit_state(1,loc(1,i)),...
                num2str(loc(1,i)),'HorizontalAlignment','right','FontSize',16,'Color','#0072BD')
            end
            yyaxis right;plot(datasetfile.scatterplot.lifetime(:,2));
            ylim([50 2510])
            legend('intensity','state fit','change point','lifetime')
            xlabel('Exp Time (s)')
            ylabel('Lifetime (ps)');
        catch
            disp('No intensity found')
        end
        %save the plot
        n=n+1;
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
%plot CCD spectrum with average wavelength
pic_num=ceil(F_leng/4);%4 plots per graph;
for i=1:pic_num
    figure
    for ii=(i-1)*4+1:i*4
        if ii<=F_leng
            hold on;plot(datasetfile.ccdt(place:end,1),...
              ...normalize(sum(datasetfile.ccdt(place:end,loc(1,ii)+2:loc(2,ii)+2),2),1,'range'),...
            mean(datasetfile.ccdt(place:end,loc(1,ii)+2:loc(2,ii)+2),2),...
            'LineWidth',3,'DisplayName',num2str(loc(1,ii)));legend
        end
    end
    n=n+1;
    %save the plot
    print(gcf, sprintf('-r%d', dpi), ...      % Print the figure at the screen resolution
      '-clipboard', '-dbitmap');
    % print(gcf,'-clipboard', '-dbitmap');
    pause (0.5);
    Ex.ActiveSheet.Range([char(68+i) num2str(files_i)]).PasteSpecial();
    Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
    Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range([char(68+i) num2str(files_i)]).Width;    %Adjusting width
    Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range([char(68+i) num2str(files_i)]).Height;  %Adjusting height
    Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
    close(gcf);    
end

end
%%
SaveAs(Exwokbook,[pathname '\' foldername ' mean spectra change.xlsx']);
Close(Exwokbook)
Quit(Ex)
end

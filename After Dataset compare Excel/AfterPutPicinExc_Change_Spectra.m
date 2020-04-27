%Under the main direction, [apd/ccd int; mesh ccd with int,ave el; mesh newccd with lf; normalized dtime along time.]
%is plotted. the origin data is from dataset.

clearvars; close all;
letter_char=num2cell(1:120);letter_box=cell(1,120);
for i=1:120
    if i<=26
        letter_box{1,i}=char(64+letter_char{1,i});
    else
        letter_box{1,i}=[char(64+floor((i-1)/26)) char(64+rem(i-1,26)+1)];
    end
end

codefolder=pwd;
%For my file need to change Generalname etc.;
folderlocation='E:\MEH substrate clean mat data\';
cd(folderlocation);
solvent='MEH_Chloroform_rmBG';
properfolder=dir(['*' solvent]);
properfolder_leng=length(properfolder);
place=22;
for properfolder_i=1:1:properfolder_leng
    pathname=[properfolder(properfolder_i).folder '\' properfolder(properfolder_i).name];
    %Open excel and try to put into proper place
    cd(pathname)
    files=dir('*dataset*.mat');
    files_leng=length(files);
    p=strfind(pathname,'\');
    foldername=pathname(p(1,end)+1:length(pathname));  
    [Ex,Exwokbook,Exsheets,Firstsheet,picrange,dpi]=Exl_prepare(files_leng,foldername);
    
    n=0;
    molecules_CND=cell(files_leng,3);
    for files_i=2:1:files_leng+1
        filename=files(files_i-1).name;
        pathname=files(files_i-1).folder;
        regularexp='\d*d\d*d\d*.mat';
        T=regexp(filename,regularexp);
        Generalname=filename(T:end-4);
        %try and catch to load everything that is possible
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
            [A.eff,A.eff_fit,~,A.numst,~]=Traceson(datasetfile.scatterplot.intensity(2,:),codefolder);
            if length(A.eff_fit(:,1))==1;A.numst=1;end
            fit_state=A.eff_fit(A.numst,:);
        end
        change_place=diff(fit_state);
        loc=find(change_place~=0);loc(1,end+1)=99;
        loc=[1,loc(1,1:end-1)+1;loc(1,:)];
        loc=loc(:,loc(1,:)<=loc(2,:));
        F_leng=length(loc(1,:));    
        
        molecules_CND{files_i-1,3}=(loc(2,:)-loc(1,:))+1;
        
        molecules_CND{files_i-1,1}=zeros(100-place+1,F_leng);
        try
            for F_leng_i=1:F_leng
                molecules_CND{files_i-1,1}(:,F_leng_i)=...
                    mean(datasetfile.ccdt(place:end,loc(1,F_leng_i)+2:loc(2,F_leng_i)+2),2);
            end
        catch; disp('Something wrong when put in to cell')
        end
        molecules_CND{files_i-1,2}=diff(molecules_CND{files_i-1,1},1,2);
        
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
        Exl_plot('C',files_i,n,Ex,dpi)
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
        Exl_plot('D',files_i,n,Ex,dpi)      
        %%
%plot into change of the spectrum
        for F_leng_i =1:F_leng-1
            figure;
            yyaxis left; plot(datasetfile.ccdt(place:end,1),molecules_CND{files_i-1,1}(:,F_leng_i),'DisplayName','Current','LineWidth',3);
                hold on; plot(datasetfile.ccdt(place:end,1),molecules_CND{files_i-1,1}(:,F_leng_i+1),'DisplayName','Next','LineWidth',3);
            yyaxis right; 
                if sum(molecules_CND{files_i-1,2}(:,F_leng_i))<0
                    hold on; plot(datasetfile.ccdt(place:end,1),molecules_CND{files_i-1,2}(:,F_leng_i)*(-1),'DisplayName',[num2str(loc(1,F_leng_i)) ' to ' num2str(loc(1,F_leng_i+1)) ' Decrease'],'LineWidth',3);
                else
                    hold on; plot(datasetfile.ccdt(place:end,1),molecules_CND{files_i-1,2}(:,F_leng_i),'DisplayName',[num2str(loc(1,F_leng_i)) ' to ' num2str(loc(1,F_leng_i+1)) ' Increase'],'LineWidth',3);
                end
            legend;title([num2str(loc(1,F_leng_i)) ' to ' num2str(loc(1,F_leng_i+1))]);
            %write into excel %save the plot
            n=n+1;
            Exl_plot(letter_box{1,4+F_leng_i},files_i,n,Ex,dpi)     
        end
 end
%%
save([pathname '\' foldername ' molecules_CND.mat'],'molecules_CND')
SaveAs(Exwokbook,[pathname '\' foldername ' Change Int.xlsx']);
Close(Exwokbook)
Quit(Ex)
end

function [Ex,Exwokbook,Exsheets,Firstsheet,picrange,dpi]=Exl_prepare(files_leng,foldername)
    Ex=actxserver('Excel.Application');
    Exwokbook=Ex.Workbooks.Add;
    Ex.Visible=1;
    Exsheets=Ex.ActiveWorkbook.Sheets;
    Firstsheet=Exsheets.get('Item',1);
    Firstsheet.Activate
    %write in folder names
    Folderrange=get(Ex.ActiveSheet,'Range',['A2:A' num2str(files_leng+1)]);
    Folderrange.Value=foldername;
    T=[{'Pathname'},{'Foldername'},{'Match plot'},{'State Separate'},{'Spectra Different Range'}];
    Titlerange=get(Ex.ActiveSheet,'Range','A1:E1');
    Titlerange.Value=T;
    dpi = get(groot, 'ScreenPixelsPerInch');  % Get screen dpi
    picrange=get(Ex.ActiveSheet,'Range',['B1:J' num2str(files_leng+1)]);
    picrange.ColumnWidth=50;
    picrange.RowHeight=100;
end
function Exl_plot(letter,files_i,n,Ex,dpi)
    print(gcf, sprintf('-r%d', dpi),'-clipboard', '-dbitmap');
    pause (0.5);
    Ex.ActiveSheet.Range([letter num2str(files_i)]).PasteSpecial();
    Ex.ActiveSheet.Shapes.Item(n).LockAspectRatio='msoFalse';            %Unlocking aspect ratio
    Ex.ActiveSheet.Shapes.Item(n).Width=Ex.ActiveSheet.Range([letter num2str(files_i)]).Width;    %Adjusting width
    Ex.ActiveSheet.Shapes.Item(n).Height=Ex.ActiveSheet.Range([letter num2str(files_i)]).Height;  %Adjusting height
    Ex.ActiveSheet.Shapes.Item(n).Placement='xlMoveandSize';
    close(gcf);
end
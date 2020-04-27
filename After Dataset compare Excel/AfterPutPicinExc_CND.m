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
    end
%%
save([pathname '\' foldername ' molecules_CND.mat'],'molecules_CND')
end
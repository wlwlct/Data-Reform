clearvars
%%
%for i=1:4;for ii=1:4;mkdir(['./' num2str(i) 'd' num2str(ii) 'd']);end;end
%for i=1:2;for ii=1:4;s=['*' num2str(i) 'd' num2str(ii) 'd*.mat'];n=struct2cell(dir(s));n_leng=length(n);for iii=1:n_leng;movefile(n{1,iii},['./' num2str(i) 'd' num2str(ii) 'd']);end;end;end
%This part use before subtract the background.
for file1=1:3
    for file2=1:4
        try
        fold=[num2str(file1) 'd' num2str(file2) 'd'];
        clearvars -except file1 file2 fold
cd(['E:\F8Se2 July\08062020\' fold]);
names=struct2cell(dir('*08062020*.mat'));
names_leng=length(names(1,:));
place=22;
matrix=zeros(100-place+1,names_leng*2);
for names_i=1:names_leng
    clearvars current wl int
    current=importdata(names{1,names_i});
    wl=current(place:end,1);
    int=mean(current(place:end,3:end),2);
    matrix(:,(names_i-1)*2+1:names_i*2)=[wl,int];
end
matrix_0=matrix;
for names_i=1:names_leng
    eval(['matrix_' num2str(names_i) '(:,2:2:names_leng*2)=matrix(:,2:2:names_leng*2)-matrix(:,names_i*2);'])
    %matrix_1 means wavelength remove first molecule as BG
    eval(['matrix_' num2str(names_i) '(:,1:2:names_leng*2)=matrix(:,1:2:names_leng*2);'])
end

n=who('matrix_*');str='';
for i=1:names_leng+1
    str=strcat(str,n{i,1});
    if i~=names_leng+1;str=strcat(str,',');end
end
cd('C:\Users\Livi\Documents\GitHub\Some-codes')
eval(['Pic2Excel_general(' str ');'])
        catch
            disp([file1 'd' file2 'd does not exist'])
        end
    end
end
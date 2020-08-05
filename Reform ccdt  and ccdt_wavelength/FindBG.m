clearvars
%%
%for i=1:4;for ii=1:4;mkdir(['./' num2str(i) 'd' num2str(ii) 'd']);end;end
%for i=1:2;for ii=1:4;s=['*' num2str(i) 'd' num2str(ii) 'd*.mat'];n=struct2cell(dir(s));n_leng=length(n);for iii=1:n_leng;movefile(n{1,iii},['./' num2str(i) 'd' num2str(ii) 'd']);end;end;end
%This part use before subtract the background.
for file1=1
    for file2=1:4
        fold=[num2str(file1) 'd' num2str(file2) 'd'];
cd(['E:\F8Se2 July\07262020\' fold]);
names=struct2cell(dir('*07262020*.mat'));
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
for names_i=1:names_leng
    eval(['matrix_' num2str(names_i) '(:,2:2:names_leng*2)=matrix(:,2:2:names_leng*2)-matrix(:,names_i*2);'])
    eval(['matrix_' num2str(names_i) '(:,1:2:names_leng*2)=matrix(:,1:2:names_leng*2);'])
end

n=who('matrix_*');str='';
for i=1:names_leng
    str=strcat(str,n{i,1});
    if i~=names_leng;str=strcat(str,',');end
end
cd('C:\Users\Livi\Documents\GitHub\Some-codes')
eval(['Pic2Excel_general(' str ');'])

    end
end
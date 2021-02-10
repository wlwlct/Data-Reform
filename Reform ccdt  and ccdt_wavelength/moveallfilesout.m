clearvars
folder='E:\F8Se2 July\08172020\ccd nrBG';
cd(folder)
select_names=struct2cell(dir('*select*'));
select_names_leng=length(select_names(1,:));
for i=1:select_names_leng
    clearvars ave_names
    ave_names=struct2cell(dir([select_names{1,i} '\ccdt_ave*']));
    ave_names_leng=length(ave_names(1,:));
    for ii=1:ave_names_leng
        movefile([select_names{1,i} '\' ave_names{1,ii} '\*'],folder)
    end
end

%move files out 
% folder='E:\F8Se2 July\08062020\ccd nrBG';
% cd(folder)
% select_names=struct2cell(dir('*select*'));
% select_names_leng=length(select_names(1,:));
% for i=1:select_names_leng
%     clearvars ave_names
%     movefile([select_names{1,i} '\*.mat'],folder)
% end
date='06272019';
cd('E:\MEH substrate clean mat data\Chloroform dataset')
names=struct2cell(dir(['MEH*' date '*']));
cd(['E:\MEH substrate clean mat data\' date '\apd'])
name_dataset=names(1,:);
name_apd=cell(1,length(name_dataset));
for i=1:length(name_dataset);clearvars r c;r=regexp(name_dataset{1,i},'\d*d\d*d\d*.mat','match');
c=dir(['*' r{1,1}]);name_apd{1,i}=c.name;end

for i=1:length(name_dataset)
    %eval(['copyfile ' name_apd{1,i} ' E:/MEH\ substrate\ clean\ mat\ data/Chloroform\ dataset/apd']);
    %C=fullfile('.\',name_apd{1,i});
    %D=fullfile('E:','MEH substrate clean mat data','Chloroform dataset','apd');
    %eval(['copyfile(' C ',' D ')']);
    copyfile(name_apd{1,i},'E:\MEH substrate clean mat data\Chloroform dataset\apd')
end
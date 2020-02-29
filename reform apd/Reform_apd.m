%%
clearvars
cd('C:\Users\Livi\Documents\Results\400nm not run\remake apd\selected ave_ccd2d2d2')
names=struct2cell(dir('02*1*'));
n=names(1,:);
for i=1:length(n);old=n{1,i};new=strrep(old,'.mat','');
    new=genvarname(strrep(new,' ',''));
    eval([new '=importdata(' char(39) names{1,i} char(39) ');']);
end
clearvars -except x0* matrix*
v=who('x0*');
BG=importdata('C:\Users\Livi\Documents\Results\400nm not run\remake apd\selected ave_ccd2d2d2\2d2d2.mat');
%%
%APD test the absolute time cut and dtime cut.
for i=1:length(v);eval(['n(i,1)=max(' v{i,1} '.PTU3file.data(:,5));']);end
absolutetime_min=min(n);
for i=1:length(v);eval(['n(i,1)=max(' v{i,1} '.PTU3file.data(:,6));']);end
bin_min=min(n);
bin_min=6250;
for i=1:length(v);eval(['n1=' v{i,1} '.PTU3file.data(:,1);']);n2=n1(2:end,1);n1=n1(1:end-1,1);u{i,1}=unique(n1-n2);end

%%
%For apd file, cut the long absolute time, change the one with long bin to
%some other number, random remove some counts based 3d3d15.

 test=BG.PTU3file.data;
 [Int_test,edg]=histcounts(test(test(:,6)~=0,6),min(test(:,6)):max(test(:,6)));
m=bin_min;
for i=1:length(v)
    clearvars PTU3file Resolution currentdata currentresolution
currentdata=eval([v{i,1} '.PTU3file.data;']);
currentresolution=eval([v{i,1} '.Resolution;']);

currentdata=currentdata(currentdata(:,5)<=(absolutetime_min),:);
loc=find(currentdata(:,6)>m);
currentdata(loc,2:6)=repmat([5 1000 0 0 0],length(loc),1);

    for ii=1:m
        rowplace=find(currentdata(:,6)==edg(1,ii));
        num_row2remove=min(length(rowplace),Int_test(1,ii));
        rowremove=rowplace(randperm(length(rowplace),num_row2remove),1);
        currentdata(rowremove,2:6)=repmat([5 1000 0 0 0],length(rowremove),1);
    end
    
PTU3file.data=currentdata;
Resolution=currentresolution;
eval(['save(' char(39) v{i,1} '.mat' char(39) ',' char(39) 'PTU3file' char(39) ',' char(39) 'Resolution' char(39) ');']);
    
end


% %try to subtract the background of apd files.(approximate, would not match the longest lifetime part)
% [Int_test,edg]=histcounts(test(test(:,6)~=0,6),min(test(:,6)):max(test(:,6)));
% for i=1:1:16;
%     Data=eval([v{i,1} '.PTU3file.data;']);
%     for ii=1:6250
%         row_place=find(Data(:,6)==edg(1,ii));
%         %compare num of rowplace with background Int, choose the min one
%         num_row2remove=min(length(row_place),Int_test(1,ii));
%         %randomly make the row of original file equal to 0
%         row2remove=row_place(randperm(length(row_place),num_row2remove),1);
%         Data(row2remove,:)=[];
%     end
% end



% %APD deal with all apd file, and resave apd file here...
% for i=1:16;
%     clearvars PTU3file Resolution;
%     test=v{i,1}(regexp(v{i,1},'3d3d*'):end);
%     eval(['PTU3file=' v{i,1} '.PTU3file; Resolution=' v{i,1} '.Resolution']);
%     eval(['save(' char(39) test '.mat' char(39) ',' char(39) 'PTU3file' char(39) ',' char(39) 'Resolution' char(39) ');']);
% end
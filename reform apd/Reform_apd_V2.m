%Bsed on the exponential decay, remove the background by randomly select
%detected photon with specific dtime.
%%
fn={'2d3d','3d1d'};
rn={'2d3d10','3d1d13'};
for fi = 1:length(fn)
clearvars -except fn rn fi
filefolder=['E:\F8Se2 July\08172020\apd rBG\',fn{1,fi}];
cd(filefolder)
names=struct2cell(dir([fn{1,fi},'*.mat']));
n=names(1,:);
for i=1:length(n);old=n{1,i};new=strrep(old,'.mat','');
    new=genvarname(strrep(new,' ',''));
    eval([new '=importdata(' char(39) names{1,i} char(39) ');']);
end
clearvars -except x* matrix* filefolder rn fn fi
v=who('x*');
BG=importdata([filefolder '\' rn{1,fi} '.mat']);
%
%APD test the absolute time cut and dtime cut.
% for i=1:length(v);eval(['n(i,1)=max(' v{i,1} '.PTU3file.data(:,5));']);end
% absolutetime_min=min(n);
for i=1:length(v);eval(['n(i,1)=max(' v{i,1} '.PTU3file.data(:,6));']);end
bin_min=min(n);
bin_min=6169;
for i=1:length(v);eval(['n1=' v{i,1} '.PTU3file.data(:,1);']);n2=n1(2:end,1);n1=n1(1:end-1,1);u{i,1}=unique(n1-n2);end

%
%For apd file, cut the long absolute time, change the one with long bin to
%some other number, random remove some counts based 3d3d15.

 test=BG.PTU3file.data;
m=bin_min;
for i=1:length(v)
    %clearvars PTU3file Resolution currentdata currentresolution 
    clearvars -except x* matrix* v BG bin_min m test i fn rn fi
      
currentdata=eval([v{i,1} '.PTU3file.data;']);
currentresolution=eval([v{i,1} '.Resolution;']);
loc=find(currentdata(:,6)>m);
currentdata(loc,2:6)=repmat([5 1000 0 0 0],length(loc),1);

%check which data range is longer
BG_col_s=find(test(:,2)==3,1);BG_abs_s=test(BG_col_s,5);
current_col_s=find(currentdata(:,2)==3,1);current_abs_s=currentdata(current_col_s,5);
[BG_abs_e,BG_col_e]=max(test(:,5));
[current_abs_e,current_col_e]=max(currentdata(:,5));

BG_l=BG_abs_e/10^9-BG_abs_s;
current_l=current_abs_e/10^9-current_abs_s;
min_l=min(current_l,BG_l);

BG_abs_e=BG_abs_s+min_l;
current_abs_e=current_abs_s+min_l;
[~,BG_col_e]=min(abs(test(:,5)/10^9-BG_abs_e));
[~,current_col_e]=min(abs(currentdata(:,5)/10^9-current_abs_e));

test_refine=test(BG_col_s:BG_col_e,:);
current_refine=currentdata(current_col_s:current_col_e,:);

%only process data after the maker
[Int_test,edg]=histcounts(test_refine(test_refine(:,6)~=0,6),min(test(:,6)):max(test(:,6)));

%currentdata=currentdata(currentdata(:,5)<=(absolutetime_min),:);

    for ii=1:m
        rowplace=find(current_refine(:,6)==edg(1,ii));
        num_row2remove=min(length(rowplace),Int_test(1,ii));
        rowremove=rowplace(randperm(length(rowplace),num_row2remove),1);
        current_refine(rowremove,2:6)=repmat([5 1000 0 0 0],length(rowremove),1);
    end
    
PTU3file.data=[currentdata(1:current_col_s-1,:);current_refine;currentdata(current_col_e+1:end,:)];
Resolution=currentresolution;
eval(['save(' char(39) v{i,1} '.mat' char(39) ',' char(39) 'PTU3file' char(39) ',' char(39) 'Resolution' char(39) ');']);
    
end
end
%%
clearvars -except fn
cd ..
desire_folder=pwd;
folders=struct2cell(dir('*d'));
for i =1:length(folders(1,:))
    for ii=1:length(fn)
        if strcmp(folders{1,i},fn{1,ii})
            cd([desire_folder '\' folders{1,i}])
            files=struct2cell(dir('x*.mat'));
            for file=1:length(files(1,:))
                movefile(files{1,file},desire_folder)
            end
        end
    end
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
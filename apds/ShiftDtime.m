%designed to move dataset, need to put check point to check how good is the
%matching.

% cd('E:\F8T2N2\apd full')
% clearvars
% days=['02012019';'02042019';'02052019'];
% days_leng=length(days(:,1));
% for days_i=1:days_leng
%     day=days(days_i,:);
%     eval(['names_' day '=struct2cell(dir([' char(39) '*' day '*' char(39) ']));']);
%     eval(['current_day=names_' day ';']);
%     oneday_leng=length(current_day(1,:));
%     eval(['name_dtime_' day '=cell(oneday_leng,2);']);
%     for oneday_i=1:oneday_leng
%         file=regexp(current_day(1,oneday_i),'\dd\dd\d*','match');
%         eval(['name_dtime_' day '{oneday_i,1}=file{1,1}{1,1};'])
%         dtime=importdata(current_day{1,oneday_i});
%         eval(['name_dtime_' day '{oneday_i,2}=cell2mat(dtime(:,2));'])
%     end
% end
% 
% dtime_name=who('name_dtime*');
% for i=1:3
%    eval(['current=' dtime_name{i,1} ';'])
%    current_leng=length(current);
%    figure
%    for ii=1:current_leng
%        hold on;clearvars disname
%        eval(['plot(normalize(sum(current{ii,2},1),' char(39) 'range' char(39) '),' char(39) 'DisplayName' char(39) ',' char(39) current{ii,1} char(39) ')'])
%    end
%    xlim([10 500])
%    legend
% end
%%
clearvars
cd('E:\F8Se2\F8Se2_CH\apd full')
ba=importdata('F8Se2 01212019 SecDtime 2d1d3.mat');
B=sum(cell2mat(ba(:,2)),1);figure('Position',[2562,393,560,420]);
date='02072019';
%files={'4d1d10';'4d1d11';'4d1d12';'4d1d13';'4d1d15';'4d1d2';'4d1d4';'4d1d5';'4d1d9'};
BG_range=50:100;
move=40;


names=struct2cell(dir(['*' date '*']));
names_leng=length(names(1,:));
files=cell(names_leng,1);
for name_i=1:names_leng
    name=regexp(names{1,name_i},'\dd\dd\d*','match');
    files{name_i,1}=name{1,1};
end
files_leng=length(files(:,1));


for files_i=1:files_leng
    clearvars -except files_i files_leng date files move B ba BG_range
    plot(normalize(B,'range'),'DisplayName','Should be');
    name=dir(['*' date '*' files{files_i,1} '.mat']);
    SecDtime=importdata(name.name);

    SecDtime_leng=length(SecDtime(:,1));SecDtime_ts=cell(SecDtime_leng,3);

    for i=1:SecDtime_leng
        Current_Sec=SecDtime{i,1};
        SecDtime_ts{i,1}=[Current_Sec(Current_Sec<=(6251-move))+move;Current_Sec(Current_Sec>(6251-move))-6251+move ];
        SecDtime_ts{i,2}=histcounts(SecDtime_ts{i,1},1:6252);
        SecDtime_ts{i,3}=length(SecDtime_ts{i,1}(:,1));
    end

    Sec=sum(cell2mat(SecDtime(:,2)),1);
    Sec_ts=sum(cell2mat(SecDtime_ts(:,2)),1);
    Sec_smooth_max=max(smoothdata(Sec,'gaussian',8));

    
    hold on;plot((Sec-mean(Sec(1,BG_range)))/(Sec_smooth_max-mean(Sec(1,BG_range))),'DisplayName','original')
    
    Sec_ts_smooth_max=max(smoothdata(Sec,'gaussian',8));
    hold on;plot((Sec_ts-mean(Sec_ts(1,BG_range)))/(Sec_ts_smooth_max-mean(Sec_ts(1,BG_range))),'DisplayName',['move' num2str(move)])
    ylim([0 1.1]);xlim([10 500]);legend;title(name.name(1:end-4));hold off

    
    clearvars -except SecDtime_ts name files_i files_leng date files move B ba Sec_smooth_max Sec_ts_smooth_max
    SecDtime=SecDtime_ts;
    save([name.name(1:end-4) '_test.mat'],'SecDtime')
end
clearvars;close all;


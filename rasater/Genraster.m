clearvars
Folder='E:\F8Se2 July\08042020\apd';
codefolder=pwd;
cd(Folder)
names=struct2cell(dir('p*d*d.txt'));
n=names(1,:);n_length=length(n);
for i=1:n_length
    new=genvarname(n{1,i}(1:end-4));
    eval([new '=importdata(names{1,i});']);
end

clearvars names n
names=struct2cell(dir('*d*dp*'));
n=names(1,:);n_length=length(n);
for i=1:n_length
    nn=strrep(n{1,i},' ','');nn=strrep(nn,'-','');
    new=genvarname(['l' nn]);
    eval([new '=importdata(names{1,i});']);
end

clearvars *Copy
clearvars -except p*d*d n_length l*d*dp*
M=who('p*d*d'); P=who('l*d*dp*');


for i=1:n_length
   eval(['current_M=transpose(' M{i} ');'])
   clearvars T
   T=regexp(M{i},'\d*d\d*d*','match');
   T=P{find(contains(P,T{1,1}))};
   thres=20;
   current_M=current_M>thres;current_M=double(current_M);
   eval(['current_P=' T ';']);
   current_P_leng=length(current_P(:,1));
   [current_M_zong,current_M_heng]=size(current_M);
   figure;scatter3(current_P(:,1),current_P(:,2),ones(current_P_leng,1)*3,100,'filled','r');view([0 0 1])
   for ii=1:current_P_leng
       text(current_P(ii,1),current_P(ii,2),3,num2str(ii),'FontSize',20,...
       'Color','r','HorizontalAlignment','right');
   end
   X=5;Y=5;
   hold on;surf(X+[1:current_M_heng]*0.1,Y+[1:current_M_heng]*0.1,current_M,'EdgeColor','none');view([0 0 1]);
   
   saveas(gcf,['F' T '.fig'])
   saveas(gcf,['F' T '.jpg'])
   close all
end


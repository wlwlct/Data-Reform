%1. write the spetra goes down and up, arange spectra side by side
clearvars;
solvent='F8T2SMS400';
molecules_CND=load('E:\F8T2400nmCH\F8T2 400nm Change Int\F8T2400nmCH molecules_CND.mat');
wl=molecules_CND.wl;molecules_CND=molecules_CND.molecules_CND;
codefolder='C:\Users\Livi\Documents\GitHub\Data-Reform\After Dataset compare Excel';
edges=450:1:670;
Folder='E:\F8T2400nmCH\F8T2 400nm Change Int';
% Plot_inc_dec(molecules_CND,wl,edges,codefolder)

wl_leng=length(wl(:,1));
CND_leng=length(molecules_CND(:,1));  total_leng=0;
for CND_leng_i=1:CND_leng;total_leng=total_leng+length(molecules_CND{CND_leng_i,2}(1,:));end

molecules_Diff=zeros(wl_leng,total_leng);
molecules_current=zeros(wl_leng,total_leng);
molecules_next=zeros(wl_leng,total_leng);
molecules_last=zeros(1,total_leng);

current_column=1;
for CND_leng_i=1:CND_leng
    clearvars current_leng
    current_leng=length(molecules_CND{CND_leng_i,2}(1,:));
    molecules_Diff(:,current_column:current_column+current_leng-1)=molecules_CND{CND_leng_i,2};
    molecules_current(:,current_column:current_column+current_leng-1)=molecules_CND{CND_leng_i,1}(:,1:current_leng);
    molecules_next(:,current_column:current_column+current_leng-1)=molecules_CND{CND_leng_i,1}(:,2:current_leng+1);
    molecules_last(1,current_column:current_column+current_leng-1)=molecules_CND{CND_leng_i,3}(1:end-1);
    current_column=current_column+current_leng;
end

molecules_Diff=rmLowInt(molecules_Diff,codefolder);
s_diff=sum(molecules_Diff,1);
% s_diff_sort=zeros(2,181);
% [s_diff_sort(1,:),s_diff_sort(2,:)]=sort(s_diff);
% figure;mesh(normalize(molecules_Diff(:,s_diff_sort(2,:)),1,'range'));view([0 0 1]);colormap(jet);
decrease_loc=find(s_diff<0);
increase_loc=find(s_diff>=0);

molecules_Diff_decrease=molecules_Diff(:,decrease_loc)*(-1);
molecules_current_decrease=molecules_current(:,decrease_loc);
molecules_next_decrease=molecules_next(:,decrease_loc);
molecules_last_decrease=molecules_last(1,decrease_loc);

molecules_Diff_increase=molecules_Diff(:,increase_loc);
molecules_current_increase=molecules_current(:,increase_loc);
molecules_next_increase=molecules_next(:,increase_loc);
molecules_last_increase=molecules_last(1,increase_loc);

stat={'decrease';'increase'};
try
%calculation order by diff
    for fig_i=1:2
        clearvars D C L N D_prepare C_prepare N_prepare L_prepare
        eval(['D=molecules_Diff_' stat{fig_i,1} ';']);eval(['C=molecules_current_' stat{fig_i,1} ';']);
        eval(['N=molecules_next_' stat{fig_i,1} ';']);eval(['L=molecules_last_' stat{fig_i,1} ';']);
        [D_prepare,C_prepare,N_prepare,L_prepare]=Spectra_prepare(D,C,N,L,wl,edges);
        eval(['[' stat{fig_i,1} '_diff_mesh,' stat{fig_i,1} '_xl]=PreparePlot(D_prepare,edges,wl);']);
        eval([stat{fig_i,1} '_current_mesh=PreparePlot(C_prepare,edges,wl);'])
        eval([stat{fig_i,1} '_next_mesh=PreparePlot(N_prepare,edges,wl);']);
        eval([stat{fig_i,1} '_xl=cellfun(@num2str,num2cell(' stat{fig_i,1} '_xl),' char(39) 'UniformOutput' char(39) ',false);']);
        
        %for mean plot
        eval(['C_mean_' stat{fig_i,1} '=zeros(wl_leng,220);']);
        eval(['D_mean_' stat{fig_i,1} '=zeros(wl_leng,220);']);
        eval(['N_mean_' stat{fig_i,1} '=zeros(wl_leng,220);']);
        eval(['L_mean_' stat{fig_i,1} '=zeros(1,220);']);
        eval(['L_std_' stat{fig_i,1} '=zeros(1,220);']);
        eval(['num_mean_' stat{fig_i,1} '=zeros(1,220);']);
        for ii=1:220
            if ~isempty(C_prepare{ii,1})
                num_mean=length(C_prepare{ii,1});
                eval(['C_mean_' stat{fig_i,1} '(:,ii)=mean(C_prepare{ii,1},2);']);
                eval(['D_mean_' stat{fig_i,1} '(:,ii)=mean(D_prepare{ii,1},2);']);
                eval(['N_mean_' stat{fig_i,1} '(:,ii)=mean(N_prepare{ii,1},2);']);
                eval(['L_mean_' stat{fig_i,1} '(1,ii)=mean(L_prepare{ii,1},2);']);
                eval(['L_std_' stat{fig_i,1} '(1,ii)=std(L_prepare{ii,1},0,2);']);
                eval(['num_mean_' stat{fig_i,1} '(1,ii)=length(C_prepare{ii,1}(1,:));']);
            end
        end
        
        %for shift plot
        eval(['[' stat{fig_i,1} '_shift_diff,' stat{fig_i,1} '_shift_current,' stat{fig_i,1} '_shift_next,~,' stat{fig_i,1} '_shi_v]=shift_distance(' stat{fig_i,1} '_diff_mesh,' stat{fig_i,1} '_current_mesh,' stat{fig_i,1} '_next_mesh,wl);'])
        eval(['loc=find(abs(' stat{fig_i,1} '_shi_v)>=5);']);loc_leng=length(loc);
        eval([stat{fig_i,1} '_shift_diff=' stat{fig_i,1} '_shift_diff(:,loc);']);
        eval([stat{fig_i,1} '_shift_current=' stat{fig_i,1} '_shift_current(:,loc);']);
        eval([stat{fig_i,1} '_shift_next=' stat{fig_i,1} '_shift_next(:,loc);']);
    end
catch
    disp('could not use Spectra_prepare')
end

%plot all spectra sort by spectra
try 
    for fig_i=1:2
        figure('Position',[[2852,1003,1170,858]]);
        %figure;
        clearvars C N D L
        eval(['C=' stat{fig_i,1} '_current_mesh;']);eval(['N=' stat{fig_i,1} '_next_mesh;']);
        eval(['D=' stat{fig_i,1} '_diff_mesh;']); eval(['L=molecules_last_' stat{fig_i,1} ';']);
        subplot(2,2,1);surfme(C,1:length(C(1,:)),wl,solvent,stat{fig_i,1},'Current');
        xticks(1:20:length(C(1,:)));eval(['xticklabels(' stat{fig_i,1} '_xl(1:20:end));']);xlabel('Wavelength (nm)')
        subplot(2,2,2);surfme(N,1:length(C(1,:)),wl,solvent,stat{fig_i,1},'Next')
        xticks(1:20:length(C(1,:)));eval(['xticklabels(' stat{fig_i,1} '_xl(1:20:end));']);xlabel('Wavelength (nm)')
        subplot(2,2,3);surfme(D,1:length(C(1,:)),wl,solvent,stat{fig_i,1},'Diff')
        xticks(1:20:length(C(1,:)));eval(['xticklabels(' stat{fig_i,1} '_xl(1:20:end));']);xlabel('Wavelength (nm)')
        subplot(2,2,4);scatter(1:length(L),L);ylabel('last time (s)')
        cd(Folder)
        saveas(gcf,[solvent ' ' stat{fig_i,1} ' order by max spectra (all).fig'])
        saveas(gcf,[solvent ' ' stat{fig_i,1} ' order by max spectra (all).jpg'])
        close all
 
        %plot mean spectra sort by spectra
        figure('Position',[2852,1003,1170,858]);
        %figure;
        subplot(2,2,1);surfme(eval(['C_mean_' stat{fig_i,1}]),edges(1,1:end-1),wl,solvent,stat{fig_i,1},'Mean Current');xlabel('Wavelength (nm)');
        subplot(2,2,2);surfme(eval(['N_mean_' stat{fig_i,1}]),edges(1,1:end-1),wl,solvent,stat{fig_i,1},'Mean Next');xlabel('Wavelength (nm)');
        subplot(2,2,3);surfme(eval(['D_mean_' stat{fig_i,1}]),edges(1,1:end-1),wl,solvent,stat{fig_i,1},'Mean Diff');xlabel('Wavelength (nm)')
        subplot(2,2,4);
        yyaxis left
        eval(['e=errorbar(edges(1:end-1),L_mean_' stat{fig_i,1} ',L_std_' stat{fig_i,1} './2);']);
        xlabel('Wavelength (nm)');ylabel('last time (s)')
        e.Marker='o';e.LineStyle='none';co=e.Color;e.MarkerEdgeColor=co;e.MarkerFaceColor=co;e.MarkerSize=10;
        yyaxis right
        eval(['scatter(edges(1:end-1),num_mean_' stat{fig_i,1} ');']);
        ylabel('number for average');xlabel('Wavelength (nm)')
        cd(Folder)
        saveas(gcf,[solvent ' ' stat{fig_i,1} ' average and last.fig'])
        saveas(gcf,[solvent ' ' stat{fig_i,1} ' average and last.jpg'])
        close all
        
        %For shift plot
        figure('Position',[2582,1003,1440,385]);
        %figure;
        subplot(1,3,1)        
        yyaxis left; surfme(eval([stat{fig_i,1} '_shift_diff']),wl,solvent,stat{fig_i,1},'Mean diff');
        yyaxis right; eval(['s=scatter3(1:loc_leng,' stat{fig_i,1} '_shi_v(loc),ones(1,loc_leng)*2);']);
        co=s.MarkerEdgeColor;s.MarkerFaceColor=co;
        
        subplot(1,3,2)        
        yyaxis left;
        surfme(eval([stat{fig_i,1} '_shift_current']),wl,solvent,stat{fig_i,1},'Mean current');
        yyaxis right; eval(['s=scatter3(1:loc_leng,' stat{fig_i,1} '_shi_v(loc),ones(1,loc_leng)*2);']);
        co=s.MarkerEdgeColor;s.MarkerFaceColor=co;
        
        subplot(1,3,3)        
        yyaxis left;
        surfme(eval([stat{fig_i,1} '_shift_next']),wl,solvent,stat{fig_i,1},'Mean next');
        yyaxis right; eval(['s=scatter3(1:loc_leng,' stat{fig_i,1} '_shi_v(loc),ones(1,loc_leng)*2);']);
        co=s.MarkerEdgeColor;s.MarkerFaceColor=co;
        
       cd(Folder)
       saveas(gcf,[solvent ' ' stat{fig_i,1} ' shift distance.fig'])
       saveas(gcf,[solvent ' ' stat{fig_i,1} ' shift distance.jpg'])
       close all
    end
catch
    disp('Could not plot')
end



%%

function [shift_diff,shift_current,shift_next,shi,shi_v]=shift_distance(sdif,scurrent,snext,wl)
    [~,scurrent_max]=max(smoothdata(scurrent,1,'gaussian',8),[],1);
    scurrent_max=transpose(wl(scurrent_max,1));
    [~,snext_max]=max(smoothdata(snext,1,'gaussian',8),[],1);
    snext_max=transpose(wl(snext_max,1));
    max_dif=snext_max-scurrent_max;
    [shi_v,shi]=sort(max_dif);
    shift_diff=sdif(:,shi);
    shift_current=scurrent(:,shi);
    shift_next=snext(:,shi);

end 
function surfme(data,x,wl,solvent,stat,current)
surf(x,wl,normalize(data,1,'range'),'EdgeColor','none');
view([0 0 1]);colormap(jet);title([solvent ' ' stat ' ' current]);
ylabel('Wavelength (nm)');
end
function FE(molecules_CND)
CND_leng=length(molecules_CND(:,1)); 
First_end=cell(CND_leng,1);
for CND_leng_i=1:CND_leng
    if length(molecules_CND{CND_leng_i,1}(1,:))>1
        First_end{CND_leng_i,1}=molecules_CND{CND_leng_i,1}(:,[1 end]);
    else
        First_end{CND_leng_i,1}=molecules_CND{CND_leng_i,1}(:,1);
    end
    %figure;plot(normalize(First_end{CND_leng_i,1}(:,1)));hold on;plot(normalize(First_end{CND_leng_i,1}(:,2)));
end
end
function spectra1=rmLowInt(spectra,codefolder)
    [spectra_zong,spectra_heng]=size(spectra);
    spectra_stage=zeros(spectra_zong,spectra_heng);
    spectra_stage_ratio=zeros(1,spectra_heng);
    for i=1:spectra_heng
        cd(codefolder)
        clearvars A
        [~,A.eff_fit,~,A.numst,~]=Traceson(spectra(:,i),codefolder);
        if ~isempty(A)
            if length(A.eff_fit(:,1))<A.numst;efffit=A.eff_fit(1,:);else;efffit=A.eff_fit(A.numst,:);end
            spectra_stage(:,i)=transpose(efffit);
            spectra_stage_ratio(1,i)=max(spectra_stage(:,i)+abs(min(spectra_stage(:,i))));
        end
    end
    
    max_int=max(spectra(:));
    spectra(end-5:end,spectra_stage_ratio<1.3)=1000+max_int;
    spectra1=spectra;
end
function [spc_diff_prepare,spc_current_prepare,spc_next_prepare,spc_max_smooth_sort]=Spectra_prepare_noOrder(Spectra_Diff,Spectra_current,Spectra_Next,wl)
%change of the spectrum, increase or decrease; plot current and next along
%with difference of spectrum
    [~,spectramax_smooth_loc]=max(smoothdata(Spectra_Diff,1,'gaussian',8),[],1);
    spc_max_smooth=transpose(wl(spectramax_smooth_loc,1));
%Order by the change of the diff of the spectrum   
    [~,spc_max_smooth_sort]=sort(spc_max_smooth);
    spc_diff_prepare=Spectra_Diff(:,spc_max_smooth_sort);
    spc_current_prepare=Spectra_current(:,spc_max_smooth_sort);
    spc_next_prepare=Spectra_Next(:,spc_max_smooth_sort);
end
function [spc_diff_prepare,spc_current_prepare,spc_next_prepare,M_last_prepare]=Spectra_prepare(Spectra_Diff,Spectra_current,Spectra_Next,M_last,wl,edges)
%change of the spectrum, increase or decrease; plot current and next along
%with difference of spectrum
    [Spectra_Diff_zong,~]=size(Spectra_Diff);
    [~,spectramax_smooth_loc]=max(smoothdata(Spectra_Diff,1,'gaussian',8),[],1);
    spc_max_smooth=transpose(wl(spectramax_smooth_loc,1));
%Order by the change of the diff of the spectrum
    spectra_edge_leng=length(edges)-1;
    spc_diff_prepare=cell(spectra_edge_leng,1);
    spc_current_prepare=cell(spectra_edge_leng,1);
    spc_next_prepare=cell(spectra_edge_leng,1);
    M_last_prepare=cell(spectra_edge_leng,1);
    for spectra_edge_i=1:spectra_edge_leng 
        clearvars spc
        spc=find((spc_max_smooth>=edges(1,spectra_edge_i)) & (spc_max_smooth<edges(1,spectra_edge_i+1)));
        spc_leng=length(spc); 
        spc_diff_prepare{spectra_edge_i,1}=zeros(Spectra_Diff_zong,spc_leng);
        spc_current_prepare{spectra_edge_i,1}=zeros(Spectra_Diff_zong,spc_leng);
        spc_next_prepare{spectra_edge_i,1}=zeros(Spectra_Diff_zong,spc_leng);
        M_last_prepare{spectra_edge_i,1}=zeros(1,spc_leng);
        for sec_i=1:spc_leng
            spc_diff_prepare{spectra_edge_i,1}(:,sec_i)=Spectra_Diff(:,spc(1,sec_i));
            spc_current_prepare{spectra_edge_i,1}(:,sec_i)=Spectra_current(:,spc(1,sec_i));
            spc_next_prepare{spectra_edge_i,1}(:,sec_i)=Spectra_Next(:,spc(1,sec_i));
            M_last_prepare{spectra_edge_i,1}(:,sec_i)=M_last(1,spc(1,sec_i));
        end
    end
end
function [mesh_prepare,labs]=PreparePlot(prepare_cell,edges,wl)
    edges_leng=length(edges)-1;
    total_spc=0;
    for edge_leng_i=1:edges_leng
        if ~isempty(prepare_cell{edge_leng_i,1})
        total_spc=total_spc+length(prepare_cell{edge_leng_i,1}(1,:));
        end
    end
    mesh_prepare=zeros(length(wl),total_spc);
    labs=zeros(1,total_spc);
    current_i=1;
    for edge_leng_i=1:edges_leng
        if ~isempty(prepare_cell{edge_leng_i,1})
            current_leng=length(prepare_cell{edge_leng_i,1}(1,:));
            labs(1,current_i:current_i+current_leng-1)=edges(1,edge_leng_i);
            mesh_prepare(:,current_i:current_i+current_leng-1)=prepare_cell{edge_leng_i,1};
            current_i=current_i+current_leng;
        end
    end
end

% A=get(gcf,'Children');
% B=get(A,'Children');
% CX=get(B{4},'XData');
% CY=get(B{4},'YData');
% CZ=get(B{4},'ZData');
% N2High_spectra_current={CX,CY,CZ};
% clearvars A B CX CY CZ
% 
% A=get(gcf,'Children');
% B=get(A,'Children');
% CX=get(B{1},'XData');
% CY=get(B{1},'YData');
% CZ=get(B{1},'ZData');
% N2High_spectra_dtime={CX,CY,CZ};
% clearvars A B CX CY CZ
% 
% A=get(gcf,'Children');
% B=get(A,'Children');
% CX=get(B{2},'XData');
% CY=get(B{2},'YData');
% CZ=get(B{2},'ZData');
% N2High_spectra_Mean={CX,CY,CZ};
% clearvars A B CX CY CZ

%%
Folder='E:\MEH substrate clean mat data\Chloroform dataset\spectra change';
N='MEHCH';
eval(['M=' N '_spectra_current;']);
eval(['A=' N '_spectra_Mean;']);
eval(['st=' N '_spectra_std;']);
eval(['D=' N '_spectra_dtime;']);

L=1:length(M{1,3}(1,:));
loc=L(any(M{1,3}));loc_leng=length(loc(1,:));

% figure;mesh(M{1}(1,loc),M{2},M{3}(:,loc));view([0 0 1]);colormap('jet')

 %%
%plot all spectra
close all
flag=1;
for loc_leng_i=1:loc_leng
    ceil_num=ceil(loc_leng_i/4);
    if flag~=ceil_num
        flag=ceil_num;
        legend;xlabel('Wavelength (nm)');ylabel('Normalized Intensity')
        cd(Folder)
        saveas(gcf,[N ' current spectra' num2str(flag) '.jpg']);
        saveas(gcf,[N ' current spectra' num2str(flag) '.fig']);
        close gcf
    end
    figure(ceil_num)
    hold on;plot(M{2},M{3}(:,loc(1,loc_leng_i)),'DisplayName',num2str(M{1}(1,loc(1,loc_leng_i))),'LineWidth',3);
    title([N 'spectra sort by wavelength at peak maxima'])
end

 %%
%plot intensity
close all
ceil_num=1:loc_leng;ceil_num=ceil(ceil_num/4);Cl_leng=length(unique(ceil_num));
figure;
for Cl_leng_i=1:Cl_leng
    cp=(Cl_leng_i-1)*4+1;
    try
        hold on; errorbar(A{1}(1,loc(1,cp:cp+3)),A{2}(1,loc(cp:cp+3)),st{2}(1,loc(cp:cp+3)),'o')
    catch
        hold on;errorbar(A{1}(1,loc(1,cp:end)),A{2}(1,loc(cp:end)),st{2}(1,loc(cp:end)),'o')
    end
end
xlabel('Max Wavelength (nm)'); ylabel('Mean and Std Intensity');title(['F8T2 ' N 'Mean intensity and Std'])
cd(Folder)
saveas(gcf,[N ' Intensity.jpg']);
saveas(gcf,[N ' Intensity.fig']);

%%
%plot intensity
close all
ceil_num=1:loc_leng;ceil_num=ceil(ceil_num/4);Cl_leng=length(unique(ceil_num));
figure;
for Cl_leng_i=1:Cl_leng
    cp=(Cl_leng_i-1)*4+1;
    try
        hold on; scatter(A{1}(1,loc(1,cp:cp+3)),A{2}(1,loc(cp:cp+3)),'o')

    catch
        hold on; scatter(A{1}(1,loc(1,cp:end)),A{2}(1,loc(cp:end)),'o')
    end
end
xlabel('Max Wavelength (nm)'); ylabel('Mean and Std Intensity')
cd(Folder)
saveas(gcf,[N ' Intensity no std bar.jpg']);
saveas(gcf,[N ' Intensity no std bar.fig']);


%%
%Dtime plot
% figure;mesh(D{1}(1,loc),D{2},D{3}(:,loc));view([0 0 1]);colormap(jet);ylim([1 3]);


flag=1;close all
for loc_leng_i=1:loc_leng
    ceil_num=ceil(loc_leng_i/4);
    if flag~=ceil_num
        flag=ceil_num;
         cd(Folder)
         saveas(gcf,[N ' current Dtime' num2str(flag) '.jpg']);
         saveas(gcf,[N ' current Dtime' num2str(flag) '.fig']);
        close gcf
    end
    F=figure(ceil_num);F.Position=[2359,945,1057,778];
    subplot(2,1,1);
        n_smooth=normalize(smoothdata(D{3}(:,loc(loc_leng_i)),1,'sgolay',11),'range');
        hold on;DP=plot(D{2},n_smooth...
            ,'LineWidth',3,'DisplayName',num2str(M{1}(1,loc(1,loc_leng_i))));xlim([1 5]);
        [~,find0d5]=min(abs(n_smooth(188:end)-0.5));find0d5=find0d5+187;
        clearvars e;e=xline(D{2}(1,find0d5));e.DisplayName='Aprrox LT';e.LineWidth=2;e.Color=DP.Color;
        legend('Location','northeastoutside');xlabel('Dtime (ns)');ylabel('Normalized Intensity')
        yline(0.5);title(['F8T2' N 'normalized Dtime'])
        
    subplot(2,1,2);
        n_not_smooth=normalize(D{3}(:,loc(loc_leng_i)),'range');
        hold on;DP=plot(D{2},n_not_smooth...
            ,'LineWidth',3,'DisplayName',num2str(M{1}(1,loc(1,loc_leng_i))));xlim([1 5]);
%         [~,find0d5]=min(abs(n_not_smooth-0.5));
        clearvars e; e=xline(D{2}(1,find0d5));e.DisplayName='Aprrox LT';e.LineWidth=2;e.Color=DP.Color;
        legend('Location','northeastoutside');xlabel('Dtime (ns)');ylabel('Normalized Intensity')
        yline(0.5);title(['F8T2' N 'non normalized Dtime'])
end

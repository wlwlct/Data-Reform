clearvars
code_folder=pwd;
file_folder='E:\02052020\CCD\1d3d';
regp='1d3d';
% Generate the background part
cd(file_folder)
names=struct2cell(dir('ave_ccd*.mat'));
n=names(1,:);
for i=1:length(n);old=n{1,i};new=strrep(old,'.mat','');
    new=genvarname(strrep(new,' ',''));
    eval([new '=importdata(' char(39) names{1,i} char(39) ');']);
end

%import all the ccdt need to substract background
clearvars names
cd(file_folder)
names=struct2cell(dir('ccdt*.mat'));
n=names(1,:);
for i=1:length(n);old=n{1,i};new=strrep(old,'.mat','');
    new=genvarname(strrep(new,' ',''));
    eval([new '=importdata(' char(39) names{1,i} char(39) ');']);
end
clearvars -except ccdt* ave* regp
v=who('ccdt*');
b=who('ave*');

%substract each background
for ii=1:length(b)
    loc=(['ccdt_' b{ii} '\']);
    for i=1:length(v)
        clearvars ccdt ccdt_wavelength
        ccdt=eval(v{i,1}); 
        na=v{i,1}(regexp(v{i,1},regp):end);
        eval(['ccdt=[ccdt(:,1:2) ccdt(:,3:end)-' b{ii,1} '(:,2)];']);
   %Calculate ccdt_wavelength
        ccdt(:,3:end)=ccdt(:,3:end)+abs(min(ccdt(:,3:end),[],1));
        eval(['ccdt_wavelength=sum(ccdt(:,1).*ccdt(:,3:end),1)./sum(ccdt(:,3:end),1);']) 
        ccdt_wavelength=[0; ccdt_wavelength'];
        try
            eval(['save(' char(39) loc 'ccdt' na '.mat' char(39) ',' char(39) 'ccdt' char(39) ');'])
            eval(['save(' char(39) loc 'ccdt_wavelength' na '.mat' char(39) ',' char(39) 'ccdt_wavelength' char(39) ');'])
        catch
            mkdir(['ccdt_' b{ii}]);
            eval(['save(' char(39) loc 'ccdt' na '.mat' char(39) ',' char(39) 'ccdt' char(39) ');'])
            eval(['save(' char(39) loc 'ccdt_wavelength' na '.mat' char(39) ',' char(39) 'ccdt_wavelength' char(39) ');'])
        end
    end
    
    
end
clearvars

% 
% cd('C:\Users\Livi\Documents\Results\Matlab code\Under development\General pic to excel');
% Pic2Excel_general(matrix1,matrix2)
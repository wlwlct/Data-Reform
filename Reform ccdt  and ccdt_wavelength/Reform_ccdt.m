%Generate ave file
folder='E:\F8Se2 July\08172020\ccd nrBG\3d1d select 3d1d13'
file='3d1d13';
cd(folder)
wpname=genvarname(['ave_ccd' file]);

loc=struct2cell(dir(['*' file '*.mat']));
ccdt=importdata([loc{2,1} '\' loc{1,1}]);

sp=[ccdt(:,1),mean(ccdt(:,3:end),2)];
eval([wpname '=sp;'])
save(['ave_ccd' file '.mat'],wpname)
%%
%get ccdt
clearvars
code_folder='C:\Users\Livi\Documents\GitHub\Data-Reform\Reform ccdt  and ccdt_wavelength';
file_folder='E:\F8Se2 July\08172020\ccd nrBG\3d1d select 3d1d13';
regp='3d1d';
place=22;
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
names=struct2cell(dir('*ccdt*.mat'));
n=names(1,:);
for i=1:length(n);old=n{1,i};new=strrep(old,'.mat','');
    new=genvarname(strrep(new,' ',''));
    eval([new '=importdata(' char(39) names{1,i} char(39) ');']);
end
clearvars -except *ccdt* ave* regp place
v=who('*ccdt*');
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
        eval(['ccdt_wavelength=sum(ccdt(' num2str(place) ':end,1).*ccdt(' num2str(place) ':end,3:end),1)./sum(ccdt(' num2str(place) ':end,3:end),1);']) 
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



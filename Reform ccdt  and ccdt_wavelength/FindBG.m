clearvars
%%
%for i=1:4;for ii=1:4;mkdir(['./' num2str(i) 'd' num2str(ii) 'd']);end;end
%for i=1:2;for ii=1:4;s=['*' num2str(i) 'd' num2str(ii) 'd*.mat'];n=struct2cell(dir(s));n_leng=length(n);for iii=1:n_leng;movefile(n{1,iii},['./' num2str(i) 'd' num2str(ii) 'd']);end;end;end
%This part use before subtract the background.

ccdfolder='E:\F8Se2 July\08172020\ccd rBG';
apdfolder='E:\F8Se2 July\08172020\apd';
apd_range=200:1000;
for file1=2:3
    for file2=1:3
        try
            fold=[num2str(file1) 'd' num2str(file2) 'd'];
            clearvars -except file1 file2 fold ccdfolder apdfolder apd_range
            cd([ccdfolder '\' fold]);
            names=struct2cell(dir('*08172020*.mat'));
            
            cd(apdfolder)
            apd_names=struct2cell(dir('*.mat'));
            
            names_leng=length(names(1,:));
            place=22;
            matrix=zeros(100-place+1,names_leng*2);
            apdmatrix=zeros(max(apd_range)-min(apd_range)+1,names_leng*2);
            
            for names_i=1:names_leng
                clearvars current wl int
                re=regexp(names{1,names_i},'\d*d\d*d\d*','match');
                %import and calculate apd part
                for apd_name_i=1:length(apd_names(1,:))
                    %disp([apd_names{1,apd_name_i},re,num2str(contains(apd_names{1,apd_name_i},re))])
                    if contains(apd_names{1,apd_name_i},re)
                        currentapd=importdata([apd_names{2,apd_name_i} '\' apd_names{1,apd_name_i}]);
                        apdtemp=currentapd.PTU3file.data(find(currentapd.PTU3file.data(:,2)==3):end,:);
                        apdmatrix(:,(names_i-1)*2+1)=1:(max(apd_range)-min(apd_range)+1);
                        A=histcounts(apdtemp(apdtemp(:,2)==9,6),1:6252);
                        apdmatrix(:,names_i*2)=A(apd_range);
                        apdmatrix(end-1:end,(names_i-1)*2+1:names_i*2)=[generatehalf(apdmatrix),0;generatehalf(apdmatrix),max(A)];
                        clearvars A
                        break
                    end
                end
                %import and calculate ccd part
                current=importdata([names{2,names_i} '\' names{1,names_i}]);
                wl=current(place:end,1);
                int=mean(current(place:end,3:end),2);
                matrix(:,(names_i-1)*2+1:names_i*2)=[wl,int];
                
            end
            matrix_0=matrix;
            namematrix=reshape([names(1,:);names(1,:)],1,[]);
            for names_i=1:names_leng
                eval(['matrix_' num2str(names_i) '(:,2:2:names_leng*2)=matrix(:,2:2:names_leng*2)-matrix(:,names_i*2);'])
                %matrix_1 means wavelength remove first molecule as BG
                eval(['matrix_' num2str(names_i) '(:,1:2:names_leng*2)=matrix(:,1:2:names_leng*2);'])
            end

            n=who('matrix_*');str='';
            n=[{'namematrix'};{'apdmatrix'};n];
            %n{end+1}='apdmatrix';
            for i=1:names_leng+1+1+1 %count matrix+namematrix+apdmatrix
                str=strcat(str,n{i,1});
                if i~=names_leng+3;str=strcat(str,',');end%count matrix+namematrix+apdmatrix
            end
            cd('C:\Users\Livi\Documents\GitHub\Some-codes')
            eval(['Pic2Excel_general(' str ');'])
        catch
            disp([num2str(file1) 'd' num2str(file2) 'd does not exist'])
        end
    end
end

function loc=generatehalf(apdmatrix)
    for i=1:length(apdmatrix(:,2));apd_sum(i,1)=sum(apdmatrix(1:i,2));end
    [~,loc]=min(abs(apd_sum-sum(apdmatrix(:,2)/2)));
    %figure;plot(test)
    %hold on;xline=test1;
    %hold on;xline(test1);
end
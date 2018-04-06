%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';

path_io = ['',computer,'eddy3D/io/']
path_lib =['',computer,'eddy3D/lib/']
%% Combine with other argo data

name = {'6902770','3901853','6903204','6900422','6903276','6901764', ...
    '6901770',  '6901766', '6901845', '6903176','6901773'};%
for a = 1:length(name)
eval(['load([path_io ''argo_',num2str(name{a}),'.mat''])'])
    eval(['lon',num2str(a),' =lon;'])
    eval(['lat',num2str(a),' =lat;'])
    eval(['time',num2str(a),'=time;'])
    eval(['pres',num2str(a),'=mpres;'])
    eval(['temp',num2str(a),'=mtemp;'])
    eval(['sal',num2str(a),' =msal;'])
    eval(['rho',num2str(a),' =mrho;'])
    clear lon lat time mpres mtemp msal mrho
end

dayi = [2015 06 01 12 0 0];%first day
day= 1:1030;%1184
time = datevec(datenum(dayi)+day-1);

for j=1:length(name)
    for i = 1:length(day)

      eval([' var= time',num2str(j),';'])
        [ind, f ]= find(datenum(time(i,1:3)) == datenum(var(:,1:3)));

        if ~isempty(ind)

            inD(i,j) = ind;
            inF(i,j) = f;

        else
            inD(i,j) = nan;
            inF(i,j) = nan;    
        end

    end

end



for i = 1:length(day)
    for j= 1:length(name)
        
        if ~isnan(inD(i,j))
        
           varlon  = [];
           varlat  = [];
           vartemp = [];
           varrho  = [];
           varsal  = [];
           varpres = [];
           eval([' varlon = lon',num2str(j),'(inD(i,j),1);']) 
           eval([' varlat = lat',num2str(j),'(inD(i,j),1);']) 
           eval([' vartemp = temp',num2str(j),'(:,inD(i,j));'])
           eval([' varrho  = rho',num2str(j),'(:,inD(i,j));']) 
           eval([' varsal  = sal',num2str(j),'(:,inD(i,j));'])   
           eval([' varpres = pres',num2str(j),'(:,inD(i,j));']) 
           
           lon(i,j)  = varlon;
           lat(i,j)  = varlat;
           temp{i,j} = vartemp;
           rho{i,j}  = varrho;            
           sal{i,j}  = varsal;            
           pres{i,j} = varpres;
           
           
        else
            
           lon(i,j)  = nan;
           lat(i,j)  = nan;  
           temp{i,j} = nan;
           rho{i,j}  = nan;        
           sal{i,j}  = nan;        
           pres{i,j} = nan;
           
        end
    end
end

filename = [path_io, '/data_perargo10.mat'];
save(filename,'time','lon','lat','temp','rho','sal','pres')



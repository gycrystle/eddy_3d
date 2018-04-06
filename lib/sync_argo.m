%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';

addpath(['',computer,'/seawater']);
addpath(genpath(['',computer,'/mixing_library']))

path_io = ['',computer,'eddy3D/io/'];
path_lib =['',computer,'eddy3D/lib/'];

%rawfile=([path_io, '/raw/6901773_20180327095720327.nc']);
%rawfile=([path_io, '/raw/6902627_097_20180329143937318.nc']);
rawfile=([path_io, '/raw/6902770_20180330114721386.nc']);
argoname='6902770';

fid = fopen(rawfile);

lat=ncread(rawfile, 'LATITUDE');
lon= ncread(rawfile,'LONGITUDE' );

pres = double(ncread(rawfile,'PRES'));
sal = double(ncread(rawfile,'PSAL'));
temp = double(ncread(rawfile,'TEMP'));

%vss = double(ncread(filename,'VERTICAL_SAMPLING_SCHEME'));

%time = day;
time = datevec(ncread(rawfile,'JULD') + datenum('1950-01-01 00:00:00'));
%
fclose(fid)    %

% If the whole column is NaN
inan=find(all(isnan(temp), 1));
temp(:,inan)=[];
pres(:,inan)=[];
sal(:,inan)=[];
time(inan,:)=[];
lon(inan,:)=[];
lat(inan,:)=[];

% Or if only surface is not NaN
inan=find(isnan(temp(10,:)));
temp(:,inan)=[];
pres(:,inan)=[];
sal(:,inan)=[];
time(inan,:)=[];
lon(inan,:)=[];
lat(inan,:)=[];
%

%project to regular grid
for i=1:size(time,1)
    nonan=find(~isnan(pres(:,i)));
    mmpres = [5:5:2000]';
    mpres(:,i) = mmpres;
    mmtemp(:,i) = interp1(pres(nonan,i),temp(nonan,i),mmpres);
    msal(:,i)  = interp1(pres(nonan,i),sal(nonan,i),mmpres);
end
%
% temp(temp==0)=nan;
% sal(sal==0)=nan;
% pres(pres==0)=nan;

PR = 10; %[db] reference pressure at surface (1bar)
mtemp = sw_ptmp(msal,mmtemp,mmpres,PR);
mrho  = sw_pden(msal,mmtemp,mmpres,PR);

%%%Save here and previus directory
%..............
matfile = ['argo_',num2str(argoname),'.mat'];
save([path_io, matfile],'lon','lat','time','mpres','mtemp','msal','mrho') 
%save([pwd '/../' matfile],'lon','lat','time','mpres','mtemp','msal','mrho')
%save([pwd '/' matfile],'lon','lat','time','mpres','mtemp','msal','mrho')


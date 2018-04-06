%
% filtering duplicated data
ganjil=1:2:378;
%
time(ganjil,:)=[];
lat(ganjil)=[];
lon(ganjil)=[];
mpres(:,ganjil)=[];
%
%
for i=1:2:378
mrhom(:,i)=(mrho(:,i)+mrho(:,i+1))./2;
end
%
mrhom(mrhom==0)=[];
mrhom=reshape(mrhom, 400, 189);
%
for i=190:195
    mrhom(:,i)=mrho(189+i);
end
mrho=mrhom;
%
% temp
for i=1:2:378
mtempm(:,i)=(mtemp(:,i)+mtemp(:,i+1))./2;
end
%
mtempm(mtempm==0)=[];
mtempm=reshape(mtempm, 400, 189);
%
for i=190:195
    mtempm(:,i)=mtemp(189+i);
end
mtemp=mtempm;

%sal
for i=1:2:378
msalm(:,i)=(msal(:,i)+msal(:,i+1))./2;
end
%
msalm(msalm==0)=[];
msalm=reshape(msalm, 400, 189);
%
for i=190:195
    msalm(:,i)=msal(189+i);
end
msal=msalm;
save('argo_6901773','time','lon','lat','mpres','mtemp','mrho','msal')

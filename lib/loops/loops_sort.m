% 3D construction from looping
% Load data and directory
computer ='/home/cgreace/tuto1/';% '~';
path_io = ['',computer,'eddy3D/io/']
%load([path_io, 'loop.mat'])
load('loop.mat')
%
mRad=80;
radius_loop=[];
rho_loop=[];
temp_loop=[];
sal_loop=[];
for iloop=1:13
    exbary=[loop.exbary];
    eybary=[loop.eybary];
    mLon(iloop)=exbary(iloop);
    mLat(iloop)=eybary(iloop);
    
   % spread(:,iloop)=[loopTSP.spread];
    for a = 1:4% argonumber;%:length(name)
        for i = 1:length(loopTSP(iloop).spread)
            xs=[];
            ys=[];
            %xs{iloop} = [mlon(iloop)  x(i,a)];
            xs{iloop} = [mLon(iloop) loopTSP(iloop).lon(i,a)];%([mlon(iloop)  x(i,a)];
            %ys{iloop} = [mlat(iloop)  y(i,a)];
            ys{iloop} = [mLat(iloop) loopTSP(iloop).lat(i,a)];
            [radius{iloop}(i,a) angle{iloop}(i,a)]= sw_dist(ys{iloop},xs{iloop},'km');
        end
    [sx{iloop}(:,a),sy{iloop}(:,a)] = pol2cart(angle{iloop}(:,a)*pi/180,radius{iloop}(:,a));
    end
    %xs_loop=[xs{iloop-1}; xs{iloop}]
    radius_loop=cat(1,radius_loop, radius{iloop});
    rho_loop=cat(1, rho_loop, loopTSP(iloop).rho);
    temp_loop=cat(1, temp_loop, loopTSP(iloop).temp);
    sal_loop=cat(1, sal_loop, loopTSP(iloop).sal);
end
Irad=radius_loop(:,1);
Irho=rho_loop(:,1);
Itemp=temp_loop(:,1);
Isal=sal_loop(:,1);

[Isort_rad, ind] = sort(Irad ,'ascend');
    %[h j]= find(isnan(Isort_rad));
    %Isort_rad(h) = [];
    %     ind(h) = [];
     Isort_temp = Itemp(ind);
     Isort_sal  = Isal(ind);
     Isort_rho  = Irho(ind);
        Istemp = [Isort_temp{1:length(Isort_rad)}];
        Issal = [Isort_sal{1:length(Isort_rad)}] ;
        Isrho = [Isort_rho{1:length(Isort_rad)}];

% for j=size(Isort_rad,1)
%     if Isort_rad(j) > mRad
%         Isort_rad(j)=[];
%         Isrho(j)=[];
%         Istemp(j)=[];
%         Issal(j)=[];
%     end
% end
pres=loopTSP(1).pres{1,1};
fileIloop = [path_io 'sortI_loop.mat'];
save(fileIloop,'pres','I*','mLon','mLat','mRad');


% Sorting the argo profiles
%
%Load directories & paths
%................................
run(['./paths.m']);
%
%name  = {'6902770','3901853','6903204','6900422'};
%
tmin=find(time(:,1)==tmin(1) & time(:,2)==tmin(2) & time(:,3)==tmin(3));
tmax=find(time(:,1)==tmax(1) & time(:,2)==tmax(2) & time(:,3)==tmax(3));
spread=tmin:tmax;
%
% [dday,~] = find(lon(:,argo_id)>eddy_lon(1) & lon(:,argo_id)<eddy_lon(2) & ...
%     lat(:,argo_id)>eddy_lat(1) & lat(:,argo_id)<eddy_lat(2) ...
%     & time(:,1)==tmin(1) & time(:,2)==tmin(2) & time(:,3)==tmin(3) ...
%     & time(:,1)==tmax(1) & time(:,2)==tmax(2) & time(:,3)==tmax(3));
% 
% spread=min(dday):max(dday);

periodT = ['',datestr(time(spread(1),:),'dd/mmm/yyyy'),'-',datestr(time(spread(end),:),'dd/mmm/yyyy'),''];
x = lon(spread,1:argonumber);
y = lat(spread,1:argonumber);


ftime = double(~isnan(lon));
date = repmat(datenum(time),1,size(lon,2)).*ftime;
date(date==0)=nan;


filter = double(~isnan(x));
[npres ]= art_cell2matrix(pres(spread,1:argonumber));
[ntemp,kk,indxx] = art_cell2matrix(temp(spread,1:argonumber));
[nsal ,~,~] = art_cell2matrix(sal(spread,1:argonumber));
[nrho ,~,~] = art_cell2matrix(rho(spread,1:argonumber));
ncp = sw_cp(nsal,ntemp,npres);

%compute mean temp/rho/cp between 200-600m
for a = 1:length(name)   
    for g = 1:length(time)
        
        if ~isnan(temp{g,a}(1))
        hheat(g,a)= nanmean(temp{g,a}(40:120)); 
        hden(g,a) = nanmean(rho{g,a}(40:120)); 
        cp = sw_cp(sal{g,a},temp{g,a},pres{g,a});
        hcp(g,a) = nanmean(cp(40:120));
        
        else
        hheat(g,a)= nan;  
        hden (g,a)= nan; 
        hcp(g,a) = nan;
        end
 
    end

end
%
%how many profiles in total?
%.......................................
% Tot_pnb  = nansum(filter,1);
% Tnb = sum(Tot_pnb);
%
%% Find profiles in and out of a given radius and moving center
%choose a radius in the main file
%
%choose a center (mean for 3 months)
%
if eddy_center==1
    run center_fixed_argo.m;
elseif eddy_center==2
    run center_fixed_aviso.m;
elseif eddy_center==3
    run center_moving_argo.m;
elseif eddy_center==4
    run center_moving_aviso.m;
else stop
end
%
% Rereference argo position depending on center above
% compute distance of every argo from this center
for a = 1:argonumber;%:length(name)
    for i = 1:length(spread)
    xs=[];
    ys=[];
    xs = [mLon  x(i,a)];
    ys = [mLat  y(i,a)];   
    [radius(i,a) angle(i,a)]= sw_dist(ys,xs,'km');
    end
    [sx(:,a),sy(:,a)] = pol2cart(angle(:,a)*pi/180,radius(:,a));
end

% Sort which profiles are in/out from chosen radius
% filter the argos in/out
outfilter = double( radius >= mRad);
outfilter(outfilter ==0)=nan;
infilter = double( radius < mRad);
infilter(infilter ==0)=nan;

outLon = x.*outfilter;
outLat = y.*outfilter;
inLon  = x.*infilter;
inLat  = y.*infilter;

% how many inside/outside?
hout= nansum(outfilter,1); hin = nansum(infilter,1);
Hout = sum(hout);          Hin = sum(hin);


% profiles out/in/all 
outtemp = temp(spread,1:argonumber);   intemp = temp(spread,1:argonumber); 
outsal  = sal(spread,1:argonumber);    insal  = sal(spread,1:argonumber); 
outrho  = rho(spread,1:argonumber);    inrho  = rho(spread,1:argonumber); 
outrad  = radius;                      inrad  = radius;      

ntemp  = temp(spread,1:argonumber);
nsal   = sal(spread,1:argonumber);
nrho   = rho(spread,1:argonumber);
nrad   = radius;
nhheat = hheat(spread,1:argonumber);
nhden  = hden(spread,1:argonumber);
nhcp   = hcp(spread,:);
nx     = sx;
ny     = sy;
nLon   = lon(spread,1:argonumber);
nLat   = lat(spread,1:argonumber);  
%nMLD   = mld2(spread,1:argonumber);
ndate  = date(spread,1:argonumber);

for a = 1:argonumber
    
    indo = [];
    indi = [];
    fo = [];
    fi = [];
    
fo = outfilter(:,a);    
[indo j]= find(isnan(fo));

outrad(indo,a) = nan;

outtemp(indo,a) = {nan};
outsal(indo,a) =  {nan};
outrho(indo,a) =  {nan};

fi = infilter(:,a);  
[indi, j]= find(isnan(fi));

inrad(indi,a) = nan;

intemp(indi,a) = {nan};
insal(indi,a) =  {nan};
inrho(indi,a) =  {nan};

end

%Seperate all inside and all outside profiles
[Ppres ]= art_cell2matrix(pres);
[Ptempout,kk,indxx] = art_cell2matrix(outtemp);
[Psalout ,~,~] = art_cell2matrix(outsal);
[Prhoout ,~,~] = art_cell2matrix(outrho);

[Ptempin,~,~] = art_cell2matrix(intemp);
[Psalin ,~,~] = art_cell2matrix(insal);
[Prhoin ,~,~] = art_cell2matrix(inrho);

%compute the mean profile representing outside/inside
%choose how many profs for the mean

% [mPtempout,rmsPtempout] = art_nanrms(Ptempout(:,kk<=argonumber),2);
% [mPtempin,rmsPtempin] = art_nanrms(Ptempin(:,kk<=argonumber),2);
% 
% [mPsalout,rmsPsalout] = art_nanrms(Psalout(:,kk<=argonumber),2);
% [mPsalin,rmsPsalin] = art_nanrms(Psalin(:,kk<=argonumber),2);
% 
% [mPrhoout,rmsPrhoout] = art_nanrms(Prhoout(:,kk<=argonumber),2);
% [mPrhoin,rmsPrhoin] = art_nanrms(Prhoin(:,kk<=argonumber),2);    
% 
% %%Save reference profiles seperately
% reffile = [path_io 'refProfout.mat'];  %only in fixed argo
% save(reffile,'mP*')


%% Sort profiles for saving
%--------------------------------------------------
% Sort inside profs
Irad  = reshape(inrad,[],1);
Itemp = reshape(intemp,[],1);
Isal  = reshape(insal,[],1);
Irho  = reshape(inrho,[],1);

[Isort_rad, ind] = sort(Irad ,'ascend');
    [h j]= find(isnan(Isort_rad));
    Isort_rad(h) = [];
         ind(h) = [];
     Isort_temp = Itemp(ind);
     Isort_sal  = Isal(ind);
     Isort_rho  = Irho(ind);
        Istemp = [Isort_temp{1:length(Isort_rad)}];
        Issal = [Isort_sal{1:length(Isort_rad)}] ;
        Isrho = [Isort_rho{1:length(Isort_rad)}];

pres= npres(:,1);
%if flagsavemat
fileI = [path_io 'sortI.mat'];
save(fileI,'Isort_*','pres','I*','in*','*in')
%end
%--------------------------------------------------
% Sort outside profs
Orad  = reshape(outrad,[],1);
Otemp = reshape(outtemp,[],1);
Osal  = reshape(outsal,[],1);
Orho  = reshape(outrho,[],1);

clear sort_*
[Osort_rad ind] = sort(Orad ,'ascend');
    [h, j]= find(isnan(Osort_rad));
    Osort_rad(h) = [];
         ind(h) = [];
     Osort_temp = Otemp(ind);
     Osort_sal  = Osal(ind);
     Osort_rho  = Orho(ind);
        Ostemp = [Osort_temp{1:length(Osort_rad)}];
        Ossal =  [Osort_sal{1:length(Osort_rad)}] ;
        Osrho =  [Osort_rho{1:length(Osort_rad)}];

%if flagsavemat
fileO = [path_io 'sortO.mat'];
save(fileO,'Osort_*','pres','O*','out*','*out')
%end
%--------------------------------------------------
% Sort all profs
Nrad  = reshape(nrad,[],1);
Ntemp = reshape(ntemp,[],1);
Nsal  = reshape(nsal,[],1);
Nrho  = reshape(nrho,[],1);
Nheat = reshape(nhheat,[],1);
Nden  = reshape(nhden,[],1);
Ncp   = reshape(nhcp,[],1);
Nx    = reshape(nx,[],1);
Ny    = reshape(ny,[],1);
Nlon  = reshape(nLon,[],1);
Nlat  = reshape(nLat,[],1);
%Nmld  = reshape(nMLD,[],1);
Ntime = reshape(ndate,[],1);

[Nsort_rad ind] = sort(Nrad,'ascend');
    [h, j]= find(isnan(Nsort_rad));
    Nsort_rad(h) = [];
         ind(h) = [];
     Nsort_temp = Ntemp(ind);
     Nsort_sal  = Nsal(ind);
     Nsort_rho  = Nrho(ind);
        Nstemp  = [Nsort_temp{1:length(Nsort_rad)}];
        Nssal   = [Nsort_sal{1:length(Nsort_rad)}];
        Nsrho   = [Nsort_rho{1:length(Nsort_rad)}];
     Nsort_heat = Nheat(ind);  
     Nsort_den  = Nden(ind); 
     Nsort_cp   = Ncp(ind);
     Nsort_x    = Nx(ind);
     Nsort_y    = Ny(ind); 
     Nsort_lon  = Nlon(ind);
     Nsort_lat  = Nlat(ind);
     %Nsort_mld  = Nmld(ind);
     Nsort_time = Ntime(ind,:);
     
%if flagsavemat
fileN = [path_io 'sortN.mat'];
save(fileN,'Nsort_*','pres','N*','mLon','mLat','mRad');
%end
%save sort_in.mat sort_out.mat sort_all.mat
%------------------------------------------------------
%%
% plot routine
%--------------------------------------------------------
%if plot_argomap
    run('./plot_argomap_.m');  
%end
%
if plot_TSD==1
    run('./plot_TSD_g.m');
    %run('./plot_TSD_.m');   
end


% clear lat lon pres rho sal temp time;
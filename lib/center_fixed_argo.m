%choose a center (mean for 3 months)
% Lon  = reshape(lon(spread,1:argonumber),[],1);
% Lat  = reshape(lat(spread,1:argonumber),[],1);
%looping_period=
% spread_c=793:862; %% limit which period of profiles to be used to fix center, used when profileris is not looping 
%                     % this one is especially for period 2017 aug 
% Lon  = reshape(lon(spread_c,argo_id),[],1);
% Lat  = reshape(lat(spread_c,argo_id),[],1);

Lon  = reshape(lon(spread,argo_id),[],1);
Lat  = reshape(lat(spread,argo_id),[],1);

for i = 1:spread;%:length(name)
mLon(i) = nanmean(Lon);
mLat(i) = nanmean(Lat);
end
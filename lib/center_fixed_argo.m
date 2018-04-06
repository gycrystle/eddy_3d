%choose a center (mean for 3 months)
% Lon  = reshape(lon(spread,1:argonumber),[],1);
% Lat  = reshape(lat(spread,1:argonumber),[],1);
Lon  = reshape(lon(spread,argo_id),[],1);
Lat  = reshape(lat(spread,argo_id),[],1);

mLon = nanmean(Lon);
mLat = nanmean(Lat);
load(['../io/ieddy16.mat'])
% Lon  = ied.xbary1;
% Lat  = ied.ybary1;
Lon  = ied.x1;
Lat  = ied.y1;
mLon = nanmean(Lon);
mLat = nanmean(Lat);
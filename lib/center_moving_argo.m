%choose a center (mean for 3 months)
Lon  = reshape(lon(spread,1:argonumber),[],1);
Lat  = reshape(lat(spread,1:argonumber),[],1);

load([path_io,'eddycenter_loops.mat'])
start=round((length(fitxargo)-length(spread))/2);
for i=1:length(spread)
mLon(i) = fitxargo(i+start)';
mLat(i) = fityargo(i+start)';
end
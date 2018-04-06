% Sorting the argo profiles
%
%Load directories & paths
%................................
run(['./paths.m']);
%
%
tmin=find(time(:,1)==tmin(1) & time(:,2)==tmin(2) & time(:,3)==tmin(3));
tmax=find(time(:,1)==tmax(1) & time(:,2)==tmax(2) & time(:,3)==tmax(3));
spread1=tmin:tmax;
%
[index(:,1),index(:,2)] = find(lon(:,:)>eddy_lon(1) & lon(:,:)<eddy_lon(2) & ...
    lat(:,:)>eddy_lat(1) & lat(:,:)<eddy_lat(2) );%...dday
%     & time(:,1)==tmin(1) & time(:,2)==tmin(2) & time(:,3)==tmin(3) ...
%     & time(:,1)==tmax(1) & time(:,2)==tmax(2) & time(:,3)==tmax(3)
% 
index2=index(find(index(:,1)<=tmax & index(:,1)>=tmin),:); %intersect(spread1,index(1,:));
spread2=intersect(spread1, sort(dday));%(min(dday)+tmin-1):(max(dday)+tmin-1);

periodT = ['',datestr(time(spread(1),:),'dd/mmm/yyyy'),'-',datestr(time(spread(end),:),'dd/mmm/yyyy'),''];
x = lon(spread1,1:argonumber);
y = lat(spread1,1:argonumber);
for i=1:size(index2,1)
xx(i,1) = lon(index2(i,1),index2(i,2));
yy(i,1) = lat(index2(i,1),index2(i,2));
end
plot(xx,yy)
figure
hold on
for i=1:11

plot(x(~isnan(x(:,1))),y(~isnan(y(:,1))),'-');
end
scatter(x(:,2),y(:,2));
scatter(x(:,3),y(:,3));
scatter(x(:,5),y(:,5));

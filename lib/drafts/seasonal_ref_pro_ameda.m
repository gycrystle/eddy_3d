%% Building a reference profile  
% while filtering argo profiles that is located inside eddy
% eddy location, center, size etc from AMEDA algorithm
% not yet started
clearvars -except path*; 
close all; clc

%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';

path_io = ['',computer,'eddy3D/io/']
path_lib =['',computer,'eddy3D/lib/']

load([path_io, 'data_perargo11.mat']);
load([path_io, 'eddy.mat']);
% plot all argo profiles location
% figure;
% hold on;
% scatter(lon(:,1),lat(:,1),'d');
% scatter(lon(:,2),lat(:,2),'+');
% scatter(lon(:,3),lat(:,3),'*');
% scatter(lon(:,4),lat(:,4),'x');
% scatter(lon(:,5),lat(:,5),'o');
% scatter(lon(:,6),lat(:,6),'+');
%
% or with time range
% season_month=[winter; spring; summer; autumn];
season_month=[12, 1, 2; 3, 4, 5; 6, 7, 8; 9, 10, 11];
season=['winter'; 'spring'; 'summer'; 'autumn'];
% Eddy locations
% input locations where we assume there is an eddy hence we will not
% use profiles in this region.
% %eddy_coord=[lonmin, lonmax, latmin, latmax]
eddy_coord=[25.1, 26.3, 33.4, 34.4;   %IE        % Need to make this input read the output of ameda
            28.2, 30, 32.5, 33.65 ] %MM ... etc  % for example eddy_coord(i,:)=[ed_center_lon(i)-rad(i), ed_center_lon+rad, ...
                                                 %                              ed_center_lat-rad, ed-center_lat-rad]
%
for k=1:size(season_month,1)
% Finding indices of profiles inside eddy
for i=1:size(eddy_coord, 1)
    [i_row,i_col]=find(lon>eddy_coord(i,1) & lon<eddy_coord(i,2) & ...
        lat>eddy_coord(i,3) & lat<eddy_coord(i,4));%
% Delete the profiles that is inside eddy from the indices above
for j=1:size(i_row,1)
    rho{i_row(j),i_col(j)}=NaN;
    sal{i_row(j),i_col(j)}=NaN;
    temp{i_row(j),i_col(j)}=NaN;
    lon(i_row(j),i_col(j))=NaN;
    lat(i_row(j),i_col(j))=NaN;
end
end
% now sorting these profiles based on their season
%i_season{k}=NaN(100);
[i_season{k},~]=find(time(:,2)==season_month(k,1));%%% to fix
%
end
winter.lon_ref=lon(i_season{1},:);
winter.lat_ref=lat(i_season{1},:);
%
for k=1:size(i_season{1},1)
    for l=1:size(rho,2)
        winter.rho_ref{k,l}=rho{i_season{1}(k),l};
        winter.sal_ref{k,l}=sal{i_season{1}(k),l};
        winter.temp_ref{k,l}=temp{i_season{1}(k),l};
    end
end
spring.lon_ref=lon(i_season{2},:);
spring.lat_ref=lat(i_season{2},:);
%
for k=1:size(i_season{2},1)
    for l=1:size(rho,2)
        spring.rho_ref{k,l}=rho{i_season{2}(k),l};
        spring.sal_ref{k,l}=sal{i_season{2}(k),l};
        spring.temp_ref{k,l}=temp{i_season{2}(k),l};
    end
end
%
summer.lon_ref=lon(i_season{3},:);
summer.lat_ref=lat(i_season{3},:);
%
for k=1:size(i_season{3},1)
    for l=1:size(rho,2)
        summer.rho_ref{k,l}=rho{i_season{3}(k),l};
        summer.sal_ref{k,l}=sal{i_season{3}(k),l};
        summer.temp_ref{k,l}=temp{i_season{3}(k),l};
    end
end
%
autumn.lon_ref=lon(i_season{4},:);
autumn.lat_ref=lat(i_season{4},:);
%
for k=1:size(i_season{4},1)
    for l=1:size(rho,2)
        autumn.rho_ref{k,l}=rho{i_season{4}(k),l};
        autumn.sal_ref{k,l}=sal{i_season{4}(k),l};
        autumn.temp_ref{k,l}=temp{i_season{4}(k),l};
    end
end
%
press=pres{607,1};
%
% for i=1:length(iref_row);
% rho_ref(:,i)=rho{iref_row(i),iref_col(i)};
% temp_ref(:,i)=temp{iref_row(i),iref_col(i)};
% sal_ref(:,i)=sal{iref_row(i),iref_col(i)};
% lon_ref(i)=lon(iref_row(i),iref_col(i));
% lat_ref(i)=lat(iref_row(i),iref_col(i));
% end
winter.rho=cell2mat((winter.rho_ref(cellfun(@(x) any(~isnan(x)),winter.rho_ref)))');
winter.mrho=nanmean(winter.rho,2);%,'omitnan'
winter.sal=cell2mat((winter.sal_ref(cellfun(@(x) any(~isnan(x)),winter.sal_ref)))');
winter.msal=nanmean(winter.sal,2);%,'omitnan'
winter.temp=cell2mat((winter.temp_ref(cellfun(@(x) any(~isnan(x)),winter.temp_ref)))');
winter.mtemp=nanmean(winter.temp,2);%,'omitnan'
%
spring.rho=cell2mat((spring.rho_ref(cellfun(@(x) any(~isnan(x)),spring.rho_ref)))');
spring.mrho=nanmean(spring.rho,2);
spring.sal=cell2mat((spring.sal_ref(cellfun(@(x) any(~isnan(x)),spring.sal_ref)))');
spring.msal=nanmean(spring.sal,2);
spring.temp=cell2mat((spring.temp_ref(cellfun(@(x) any(~isnan(x)),spring.temp_ref)))');
spring.mtemp=nanmean(spring.temp,2);
%
summer.rho=cell2mat((summer.rho_ref(cellfun(@(x) any(~isnan(x)),summer.rho_ref)))');
summer.mrho=nanmean(summer.rho,2);
summer.sal=cell2mat((summer.sal_ref(cellfun(@(x) any(~isnan(x)),summer.sal_ref)))');
summer.msal=nanmean(summer.sal,2);
summer.temp=cell2mat((summer.temp_ref(cellfun(@(x) any(~isnan(x)),summer.temp_ref)))');
summer.mtemp=nanmean(summer.temp,2);
%
autumn.rho=cell2mat((autumn.rho_ref(cellfun(@(x) any(~isnan(x)),autumn.rho_ref)))');
autumn.mrho=nanmean(autumn.rho,2);
autumn.sal=cell2mat((autumn.sal_ref(cellfun(@(x) any(~isnan(x)),autumn.sal_ref)))');
autumn.msal=nanmean(autumn.sal,2);
autumn.temp=cell2mat((autumn.temp_ref(cellfun(@(x) any(~isnan(x)),autumn.temp_ref)))');
autumn.mtemp=nanmean(autumn.temp,2);
%
winter.lon=winter.lon_ref(~isnan(winter.lon_ref));
winter.lat=winter.lat_ref(~isnan(winter.lat_ref));
%
spring.lon=spring.lon_ref(~isnan(spring.lon_ref));
spring.lat=spring.lat_ref(~isnan(spring.lat_ref));
%
summer.lon=summer.lon_ref(~isnan(summer.lon_ref));
summer.lat=summer.lat_ref(~isnan(summer.lat_ref));
%
autumn.lon=autumn.lon_ref(~isnan(autumn.lon_ref));
autumn.lat=autumn.lat_ref(~isnan(autumn.lat_ref));
%
figure
hold on
win=scatter(winter.lon, winter.lat, 'filled');
sum=scatter(summer.lon, summer.lat, 'filled');
spr=scatter(spring.lon, spring.lat, 'filled');
aut=scatter(autumn.lon, autumn.lat, 'filled');
hold off
win.MarkerFaceColor=[0,0.45,0.74];
sum.MarkerFaceColor=[1,0.1,0.4];
spr.MarkerFaceColor=[0.47,0.9,0.19];
aut.MarkerFaceColor=[1,0.6,0];
% legend([win spr sum aut], {'winter','spring', 'summer', 'autumn'});%, 'Location', 'Best'
%
figure
subplot(1,3,1); %% ==Temperature==
hold on
plot(winter.temp, press,'Color',[0.6,0.8,1]); %
plot(summer.temp, press, 'Color',[1,0.8,0.8]);
plot(spring.temp, press, 'Color',[0.6,1,0.6]);
plot(autumn.temp, press, 'Color',[1,0.97,0.6]);
plot(spring.mtemp, press, 'Color',[0.47,0.9,0.19],'LineWidth',2);
plot(autumn.mtemp, press, 'Color',[1,0.6,0],'LineWidth',2);
plot(winter.mtemp, press, 'Color',[0,0.45,0.74],'LineWidth',2);
plot(summer.mtemp, press, 'Color',[1,0.1,0.4],'LineWidth',2);
ylim([0 800])
%xlim([1025.7 1029.4])
xlabel('Temperature (�C)');
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
hold off

subplot(1,3,2); %% ==Salinity==
hold on
plot(winter.sal, press, 'Color',[0.6,0.8,1]);
plot(summer.sal, press, 'Color',[1,0.8,0.8]);
plot(spring.sal, press, 'Color',[0.6,1,0.6]);
plot(autumn.sal, press, 'Color',[1,0.97,0.6]);
plot(spring.msal, press, 'Color',[0.47,0.9,0.19],'LineWidth',2);
plot(autumn.msal, press, 'Color',[1,0.6,0],'LineWidth',2);
plot(winter.msal, press, 'Color',[0,0.45,0.74],'LineWidth',2);
plot(summer.msal, press, 'Color',[1,0.1,0.4],'LineWidth',2);
ylim([0 800])
%xlim([1025.7 1029.4])
xlabel('Salinity (psu)');
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
hold off
%
subplot(1,3,3); %% ==Density==
hold on
plot(winter.rho, press, 'Color',[0.6,0.8,1]);
plot(summer.rho, press, 'Color',[1,0.8,0.8]);
plot(spring.rho, press, 'Color',[0.6,1,0.6]);
plot(autumn.rho, press, 'Color',[1,0.97,0.6]);
sp=plot(spring.mrho, press, 'Color',[0.47,0.9,0.19],'LineWidth',2);
au=plot(autumn.mrho, press, 'Color',[1,0.6,0],'LineWidth',2);
wi=plot(winter.mrho, press, 'Color',[0,0.45,0.74],'LineWidth',2);
su=plot(summer.mrho, press, 'Color',[1,0.1,0.4],'LineWidth',2);
% legend([wi sp su au],{'winter','spring', 'summer', 'autumn'}, 'Location', 'Best');
ylim([0 800])
xlim([1025.7 1029.4])
legend('boxoff')
xlabel('Salinity (psu)');
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
hold off


save('ref_pro11.mat', 'press', 'winter', 'spring', 'summer', 'autumn')
%save('ref_pro.mat', 'press', 'temp_ref', 'sal_ref', 'rho_ref', 'lon_ref', 'lat_ref')


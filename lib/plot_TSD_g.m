%% Plot TSD
%clearvars -except eddy eddy_center ; 
%close all; clc
%run(['./paths.m']);
%load ('/../io/ref_pro.mat', '/../io/SortI.mat');
load ([path_io, 'ref_pro.mat']);
load ([path_io, 'sortI.mat']);
%, 
ioi=find(Isort_rad<mRad2);
figure
subplot(1,3,1); %% ==Temperature==
hold on
plot(Istemp, press, 'Color',[0.6,0.8,1]); %lightblue
% plot(Istemp(:,ioi), press, 'Color',[0.6,0.8,1]); %lightblue
% plot(Istemp(:,(ioi(end)+1):end), press, 'Color',[1, 0.6, 0.7843]); %pink
plot(autumn.mtemp, press, 'Color',[1,0.6,0],'LineWidth',2); 
plot(Istemp(:,ioi(end)), press(:,1), 'Color',[0,0.45,0.74]); %blue
plot(Istemp(:,1), press, 'Color',[1,0.1,0.4]);%red
ylim([100 800])
xlabel('Temperature (°C)');
ylabel('Depth (dbar)');
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
hold off
%
subplot(1,3,2); %% ==Salinity==
hold on
plot(Issal, press, 'Color',[0.6,0.8,1]); %lightblue
% plot(Issal(:,ioi), press, 'Color',[0.6,0.8,1]); %lightblue
% plot(Issal(:,(ioi(end)+1):end), press, 'Color',[1, 0.6, 0.7843]); %pink
plot(autumn.msal, press, 'Color',[1,0.6,0],'LineWidth',2); 
plot(Issal(:,ioi(end)), press(:,1), 'Color',[0,0.45,0.74]); %blue
plot(Issal(:,1), press, 'Color',[1,0.1,0.4]);%red
ylim([100 800])
%xlim([1025.7 1029.4])
xlabel('Salinity (psu)');
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
hold off
%
subplot(1,3,3); %% ==Density==
hold on
plot(Isrho, press, 'Color',[0.6,0.8,1]); %lightblue
% plot(Isrho(:,ioi), press, 'Color',[0.6,0.8,1]); %lightblue
% plot(Isrho(:,(ioi(end)+1):end), press, 'Color',[1, 0.6, 0.7843]); %pink
refp=plot(winter.mrho, press, 'Color',[1,0.6,0],'LineWidth',2); 
out=plot(Isrho(:,ioi(end)), press(:,1), 'Color',[0,0.45,0.74]); %blue
in=plot(Isrho(:,1), press, 'Color',[1,0.1,0.4]);%red
legend([refp out in],{'reference','outmost', 'inmost'}, 'Location', 'southwest');
ylim([100 800])
%xlim([1025.7 1029.4])
legend('boxoff')
xlabel('Density (kg/m^3)');
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
hold off
%
print( '-dpng',[path_output, 'TSD_eddy_profiles'] )




%% Plot profile locations for the reference
%clearvars -except path* eddy*
%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';
%
addpath(['',computer,'/m_map']);
%addpath(['',computer,'/matfun']);
addpath(['',computer,'/matpalettes']);
%addpath(['',computer,'/seawater']);
%addpath(genpath(['',computer,'/mixing_library']))
addpath(['',computer,'/bathy']);
%path_argo = ['',computer,'/MARGO/'];
%addpath([path_argo 'argofun/']);
path_io = ['',computer,'eddy3D/io/']
path_lib =['',computer,'eddy3D/lib/']
load([path_io, '/ref_pro.mat']);

season={'winter', 'spring', 'summer', 'autumn'}
season_color={[0,0.45,0.74], [0.47,0.9,0.19], [1,0.1,0.4], [1,0.6,0]};
%
% Boundaries for map plot
minlat = 31;                                                      
maxlat = 37;                                                       
minlon = 23;                                                        
maxlon = 33;
%
row=[length(winter.lon), length(spring.lon), length(summer.lon),length(autumn.lon)];
lon=NaN([max(row) length(season)]);
lat=lon;
for i=1:length(season)
    loni=eval([season{i},'.lon']);
    lati=eval([season{i},'.lat']);
    for j=1:row(i)
        lon(j,i)=loni(j);
        lat(j,i)=lati(j);
    end
    clearvars loni lati
end

    % map plot
    h_coast=1; bath=0;
    if h_coast; coast=csvread('bathy/new_bathy.csv');end
    if bath;    load('bathy/bathy_med');end
    %
    m_proj('Mercator','lat',[minlat maxlat],'lon',[minlon maxlon]);
    %
    hmap = figure;
    for a = 1:length(season) %argonumber;%length(name)
        
        notnan = find(~isnan(lon(:,a)));
        xx = lon(:,a);
        yy = lat(:,a);
        m = m_plot(xx,yy,'Color',season_color{a},... %%mark{a},
            'MarkerFaceColor',season_color{a},...
            'MarkerSize',5,'linewidth',0.3,'linestyle','none');
        
        eval(['m',num2str(a),'= m;'])
        legendInfo{a} = ['',season{a},' '];
        hold on
    end
    legend(legendInfo,'location','northwest')
%     t = title(periodT,'fontsize',10);
%     set(t, 'horizontalAlignment', 'left')
%     set(t, 'units', 'normalized')
%     h1 = get(t, 'position');
%     set(t, 'position', [h1(3) h1(2) 1])
    if h_coast
        [X,~]=m_ll2xy(coast(:,1),coast(:,2),'clip','patch');
        k=find(isnan(X(:,1)));
        for i=1:length(k)-1,
            xc=coast([k(i)+1:(k(i+1)-1) k(i)+1],1);
            yc=coast([k(i)+1:(k(i+1)-1) k(i)+1],2);
            m_patch(xc,yc,[.9 .9 .9]);
        end
    else
        m_coast('color','k');
    end
    m_grid('tickdir','in','xtick',4,'ytick',4,'linewidth',1,'Fontsize',11);
    %
    
    figname ='Reference_Location';
    print(hmap,[path_output, figname],'-dpng','-r300')
%
%---------------------------------------------------------------------
%% Plot reference profile
plotref_pro=figure
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
ylim([100 800])
xlim([13 18])
xlabel('Temperature (°C)');
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
ylim([100 800])
%xlim([38.5 1029.4])
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
legend([wi sp su au],{'winter','spring', 'summer', 'autumn'}, 'Location', 'southwest');
ylim([100 800])
xlim([1028.5 1029.3])
legend('boxoff')
xlabel('Density (kg/m^3)');
set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
hold off

figname ='Reference_Profile';
print(plotref_pro,[path_output, figname],'-dpng','-r300')

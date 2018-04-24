clear all;clc;close all
computer ='/home/cgreace/tuto1/';% '~';

%Load argo
%................................
%path_argo = ['',computer,'/Documents/IMED/ANALYSIS/MARGO/argos/']
path_argo = ['',computer,'/MARGO/'];
path_input = ['',computer,'eddy3D/input/']
path_io = ['',computer,'eddy3D/io/']
addpath(['',computer,'/m_map']);
addpath(['',computer,'/matfun']);
addpath(['',computer,'/matpalettes']);
addpath(['',computer,'/seawater']);
addpath(genpath(['',computer,'/mixing_library']))
addpath(['',computer,'/bathy']);
path_argo = ['',computer,'/MARGO/'];
addpath([path_argo 'argofun/']);

addpath(['',computer,'/MATLAB/AMEDA/tools/'])

h_coast=1;if h_coast; coast=csvread('bathy/new_bathy.csv');end
    minlat = 32.2;                                                      
    maxlat = 34.3;                                                       
    minlon = 28;                                                        
    maxlon = 30.5;      
m_proj('Mercator','lat',[minlat maxlat],'lon',[minlon maxlon]);

%Load argo
%................................
% IMS METU - Middle East Technical University - Institute of Marine Sciences - Turkey
% OGS  - Pierre-Marie POULAIN - Istituto Nazionale di Oceanografia e di Geofisica Sperimentale 
% HCMR - Hellenic Centre for Marine Research, Institute of Oceanography - Greece
% LOV  - Laboratoire Oceanographique de Villefranche - France - 6901770 &6901764
% NAVO - Naval Oceanographic Office 
%path_argo = ['',computer,'/Documents/IMED/ANALYSIS/MARGO/Argos_/argos/'];
    name  = {'6902770'}%,'3901853','6903204','6900422'};%,'6903276','6901764'}
    info  = {'SHOM','IMS METU','OGS','NAVO','HCMR','LOV'};%,'LOV'}
    col   = {[0.7 0 0 ],'k',[0 0.5 0],'b',rgb('DimGray'),rgb('DarkBlue'),rgb('DarkBlue')};
    facol = {'w','k',[0 0.5 0],'w','w','w',rgb('DimGray')};
    mark  = {'o','d','o','o','o','d','d'}; 

load([path_io, 'sortI.mat'])
npres = pres;
load([path_io, 'data_perargo11.mat'])
load([path_io, 'ref_pro.mat']) 

%well defined loops
loop_pstart=[2017,10,6; ...
    2017,10,13; ...
    2017,10,19; ...
    2017,10,29; ...
    2017,11,4; ...
    2017,11,6; ...
    2017,11,15; ...
    2017,11,20; ...
    2017,11,25; ...
    2017,12,2; ...
    2017,12,12; ...
    2017,12,20; ...
    2017,12,29; ...
    2018,1,5];
loop_pend=[2017,10,18; ...
    2017,10,23; ...
    2017,10,31; ...
    2017,11,6; ...
    2017,11,14; ...
    2017,11,18; ...
    2017,11,23; ...
    2017,11,28; ...
    2017,12,3; ...
    2017,12,16; ...
    2017,12,26; ...
    2018,1,3; ...
    2018,1,14; ...
    2018,1,23];

% lap = {30:31+10,...
%       93:93+8,...
%       93+12:93+12+10,...
%       110:110+8,...
%       115:115+11}

for l = 1:size(loop_pstart,1)
    
spread  =[];
pstart(l)=find(time(:,1)==loop_pstart(l,1) & time(:,2)==loop_pstart(l,2) & time(:,3)==loop_pstart(l,3));
pend(l)=find(time(:,1)==loop_pend(l,1) & time(:,2)==loop_pend(l,2) & time(:,3)==loop_pend(l,3));
spread = pstart(l):pend(l); %find(   lap{l}

figure
ax1=subplot(131)
i = spread;
for j = 1:length(name)
    x=[]; xx=[];
    y=[]; yy= [];
    x = lon(i,j);
    y = lat(i,j);
    yy =  y(~isnan(y));
    xx =  x(~isnan(x));
    if ~isempty(yy)
        m_plot(xx,yy,mark{j},'color',col{j},...
                            'MarkerFaceColor',facol{j},...
                            'MarkerSize',6,...
                            'linewidth',0.3,'linestyle','--'); 
        hold on  
    end
   
    
end
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
m_grid('tickdir','in','xtick',4,'ytick',4,'linewidth',1,'Fontsize',14); 
axes(ax1)
dste = ['',datestr(time(spread(1),:),'dd/mmm'),'--',datestr(time(spread(end),:),'dd/mmm'),'']
text(-0.039,0.675,dste,'Fontsize',10)

subplot(132)
for i = spread
    for j = 1:length(name)
    plot(temp{i,j},pres{i,j},'color',col{j})
    hold on
    xlim([13 18])
    ylim([0 1000])
    axis ij
    end
end
    ax = gca;
    hold on
    plot(ax,autumn.mtemp,press,'k--','linewidth',1.5)
    set(ax,'xaxisLocation','top')
    xlabel('Temperature (^oC)');
    
    
subplot(133)
for i = spread
    for j = 1:length(name)
    plot(rho{i,j},pres{i,j},'color',col{j})
    hold on
    xlim([1028.4 1029.3])
    ylim([0 1000])
    axis ij
    end
end
    hold on
    plot(autumn.mrho,press,'k--','linewidth',1.5)
    ax = gca;
    set(ax,'xaxisLocation','top')
    xlabel('Density (kg/m^3)');
    
figname = ['lloopTS',datestr(time(spread(1),:),'dd-mmm'),'_',datestr(time(spread(end),:),'dd-mmm'),'']
print(gcf,figname,'-dpng','-r300')    
end

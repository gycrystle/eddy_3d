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
addpath(genpath(['',computer,'/mixing_library']))
addpath(['',computer,'/bathy']);
path_argo = ['',computer,'/MARGO/'];
addpath([path_argo 'argofun/']);
addpath('../loops_tool')
addpath(['',computer,'/AMEDA/tools/'])


% addpath(['',computer,'/MATLAB/matpalettes'])
% addpath(['',computer,'/MATLAB/matfun'])
% addpath(['',computer,'/MATLAB/artfun'])
map = brewermap(8,'*PiYG')

filename = ['loop.mat']
load(filename,'loop')


fs = 10
figure
for i = 1:length(loop)-1

Srmax  = loop(i).ermax
Svmax  = loop(i).evmax
Srmaxrms = loop(i).rmsrmax
Sellip = loop(i).ellip

hold all
     herrorbar(Srmax(1),Svmax(1),Srmaxrms(1),'k')
p1(i) = scatter(Srmax(1),Svmax(1),100,Sellip(1),'filled','MarkerEdgecolor','k')

%     herrorbar(Srmax(2),Svmax(2),Srmaxrms(2),'k')
%p2(i) = scatter(Srmax(2),Svmax(2),100,Sellip(2),'s','filled','MarkerEdgecolor','k')

% t1(i) = text(Srmax(1),Svmax(1)+0.05*Svmax(1),num2str(i))
% t2(i) = text(Srmax(2),Svmax(2)+0.05*Svmax(2),num2str(i))


end
load(['vel/fixed/vel_param2.mat'])
gen_fix_velC=velC;
clearvars vel*

load(['vel/moving/vel_param2.mat'])
gen_mov_velC=velC;
clearvars vel*

load([path_io, 'vel_param2.mat'])
gen_vel_loop=velC
clearvars vel*

load([path_io, 'vel_param3.mat'])
p3_vel_loop=velC
clearvars vel*

rrvel=linspace(0,80,81);
c=colorbar
xlim([0 80]);
ylim([0 0.5]);
caxis([0 0.4])
colormap(map)
box on
axis square;
grid on;
ax = gca;
ax.GridLineStyle = ':'
ax.GridColor = 'k';
set(gca,'Xtick',[0:10:80])
set(gca,'linewidth',0.5)
title(c,'\bf \epsilon','Fontsize',fs)
set(gca,'Ytick',[0:0.05:0.5])
set(gca,'Xtick',[0:10:80])
set(gca,'linewidth',0.5,'fontsize',fs)
xlabel('R (km)');ylabel('V (m/s)');
set(gca,'layer','top')   
vel_fix=plot(rrvel, gen_fix_velC(20,120:-1:40),'b');
vel_mov=plot(rrvel, gen_mov_velC(20,120:-1:40),'r');
vel_loop2p=plot(rrvel, gen_vel_loop(20,120:-1:40),'g');
vel_loop3p=plot(rrvel, p3_vel_loop(20,120:-1:40),'k');
leg = legend([p1(3) vel_fix vel_mov vel_loop2p vel_loop3p],'looping velocity @ z = 100m',...
    'Cyclogeo Vel with fixed center', 'Cyclogeo Vel with moving center', ...
    'Cyclogeo Vel with looping + generic fitting', 'Cyclogeo Vel with fixed center + 3 param fit', ...
    'location','northwest')    % p2(3)    
fignamef = ['multi_VR_V']
print(gcf,fignamef,'-dpng','-r300')  


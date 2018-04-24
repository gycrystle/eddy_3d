clear all;clc;close all
computer = '~/Documents'
addpath(['',computer,'/MATLAB/matpalettes'])
addpath(['',computer,'/MATLAB/geom2d/geom2d'])
addpath(['',computer,'/MATLAB/matfun'])
map = brewermap(8,'*PiYG')


mark = {'o','','','s'}
figure
i = 1
for j = [1 4]
    
    filename = ['traj_loops_',num2str(j),'.mat']
    load(filename,'loop')
    nloop = length(loop(i).xint)

    for jj = 1:nloop

    Srmax  = loop(i).rmax{1,jj}
    Svmax  = loop(i).velmax{1,jj}
    % Srmaxrms = loop(i).rmsrmax{1,j}
    Sellip = loop(i).ellip{1,jj}

    if Sellip<=0.3
    hold all
    p(i)=scatter(Srmax(1),Svmax(1),100,Sellip(1),'filled',mark{i},'MarkerEdgecolor','k')
    % herrorbar(Srmax(1),Svmax(1),Srmaxrms(1),'k.')
    end
    
    end
    
end

% l = legend([p(1) p(4)],'z = 100m','z = 350m','location','northwest')
c=colorbar
xlim([0 60]);
ylim([0 0.5]);
caxis([0 0.4])
colormap(map)
box on
axis square;
grid on;
ax = gca;
ax.GridLineStyle = ':'
ax.GridColor = 'k';
set(gca,'Xtick',[0:10:60])
set(gca,'linewidth',0.5)
title(c,'\bf \epsilon','Fontsize',12)
title(c,'\bf ε','Fontsize',12)
set(c,'YTick',0.1:0.05:0.4)
% ylabel(c,'Ellipticity','Fontsize',12)
xlabel('R (km)');ylabel('V (m/s)');
set(gca,'layer','top')

d1 = plot(0,0,mark{1},'color','k','visible','off')
d4 = plot(0,0,mark{4},'color','k','visible','off')
[h,icons,plots,legend_text] = legend([d1 d4],'z = 100m','z = 350m','location','northwest')
set(h,'fontsize',10)
set(plots,'MarkerSize',10)


figname = ['multi_VR']
print(gcf,figname,'-dpng','-r150')    



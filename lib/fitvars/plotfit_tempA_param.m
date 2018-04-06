clear;clc;close all
computer = '~/Documents';
addpath(['',computer,'/MATLAB/matpalettes'])
path_argo = ['',computer,'/IMED/ANALYSIS/MARGO/'];
addpath([path_argo 'argofun/'])

%Load Fields
frame = 'argo';
field = {'tempA','salA','rhoA'};    f = 1; 
disp(['----- Field: ',num2str(field{f}), '-----',num2str(frame),''])
  

%Flags figs
flagfig1 = 0;
figmld   = 0;
flagfig2 = 1; 
yPARM = {'\delta T_{anom}','B','Rmax','\alpha'}
yLIMS = {[0 2],[-1 1]*1e-4,[0 60],[0 4]};

for param = 3:4

namefig2 = ['../fit',num2str(frame),'_',num2str(field{f}),'_param',num2str(param),'.png'];
filesave = ['sortN_',num2str(field{f}),'_fitparam',num2str(param),'.mat'];
load(filesave)



% Start the evaluation
sdeep = 1:400
pres  = Z(sdeep);
r     = -100:1:100;
   
Lewq =[];
Cewq =[];
for deep = sdeep
    
x = distance';
y = varA(deep,:);

       Input = real(lsqFit(deep,:));
Lewq(deep,:) = funFit(Input,r);

   

 if flagfig1
 hfig = figure('visible','off')
 hold all
 scatter(x,y)
 plot(r,Lewq(deep,:),'k','linewidth',1);
 title(['Depth: ',num2str(Z(deep)),'m'])
 saveas(hfig,['./levels/fitting_param',num2str(param),'_',num2str(Z(deep)),'.png'])
 close(hfig)
 end
end

    figure
    for pp = 1:param
        if param ==2 && pp ==param

            subplot(2,2,pp+1)
            plot(pres,lsqFit(:,pp),'k')
            xlabel('Pressure (dbar)')
            ylim([yLIMS{pp+1}])
            ylabel(yPARM{pp+1})
            hold on    
        else
            subplot(2,2,pp)
            plot(pres,lsqFit(:,pp),'k')
            xlabel('Pressure (dbar)')
            ylim([yLIMS{pp}])
            ylabel(yPARM{pp})
            hold on    

        end
    end
    saveas(gcf,['param',num2str(param),'',num2str(field{f}),'_input0.png'])


name = {'Cewq','Lewq'}
for i = 2
    ewq =[];
    eval(['var = ',name{i},';'])
    
ewq = real(var);
sdeep = 1:400;

hfig = figure
pcolor(r,pres(sdeep,:),ewq(sdeep,:)),shading flat
axis ij
caxis([-2 2])
colormap(brewermap(50,'*RdBu'))
ax = gca;
set(ax,'Xtick',[-200:30:200])
set(ax,'Ytick',[0:100:1500])
ylim([0 1500])
set(ax,'xaxisLocation','top')
ylabel(ax,'Pressure (dbar)','FontSize',10)
xlabel(ax,'Radius (km)','FontSize',10)
c=colorbar
title(c,{'\delta T';'(^oC)'})
hold all
v = [-3:0.2:3]
v(v==0) = []
[C hT]=contour(r,pres,ewq,v,'k')
set(hT,'LineWidth',0.5,'Color','k','linestyle','-');
clabel(C,hT,v,'LabelSpacing',100,'Fontsize',7)    
set(ax,'linewidth',1)
set(ax,'layer','top')
axis square
title('Temperature Anomaly')



if flagfig2
saveas(gcf,namefig2)
end

end


end


clearvars -except eddy* path* no_param;
clc;
%run(['./paths.m']);
%Load Fields
if or(eddy_center==1, eddy_center==3)
    frame = 'argo';
else
    frame = 'aviso';
end
%
for f=1:3
field = {'tempA','salA','rhoA'};    %f = 3; 
disp(['----- Field: ',num2str(field{f}), '-----',num2str(frame),''])
  
%Flags figs
flagfig1 = 0;
figmld   = 0;
flagfig2 = 1; 
yparname={'\deltatemp_{anom}', '\deltasal_{anom}','\delta\rho_{anom}' };
yPARM = {yparname{f},'B','Rmax','\alpha'};
yparlim={[0 3], [0 .2], [-.8 0]} ;
yLIMS = {yparlim{f},[-1 1]*1e-4,[25 60],[1.5 5.5]};

for param = 2:4

namefig2 = [path_output, 'fit',num2str(frame),'_',num2str(field{f}),'_param',num2str(param),'.png'];

filesave = [path_io, 'sortN_',num2str(field{f}),'_fitparam',num2str(param),'.mat'];
load(filesave)

if figmld
load([path_argo 'Argos_/mixed_layer/mld6902770.mat'])
avemld = nanmean(mld);
maxmld = nanmax(mld);
end

% Start the evaluation
sdeep = 20:200;
pres  = Z(sdeep);%
r     = -120:1:120;
   
Lewq =[];
Cewq =[];
for deep = sdeep
    
x = distance';
y = varA(deep,:);

       Input = real(lsqFit(deep,:));
       eval(['Lewq(deep,:) = funFit',num2str(param), '(Input,r);']);  
%Lewq(deep,:) = funFit(Input,r);

   
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
            plot(pres,lsqFit(sdeep,pp),'k')
            xlabel('Pressure (dbar)')
            ylim([yLIMS{pp+1}])
            ylabel(yPARM{pp+1})
            hold on    
        else
            subplot(2,2,pp)
            plot(pres,lsqFit(sdeep,pp),'k')
            xlabel('Pressure (dbar)')
            ylim([yLIMS{pp}])
            ylabel(yPARM{pp})
            hold on    

        end
    end
    saveas(gcf,['param',num2str(param),'',num2str(field{f}),'_input0.png'])


name = {'Cewq','Lewq'};
for i = 2
    ewq =[];
    eval(['var = ',name{i},';'])
    
ewq = real(var);
hfig = figure;
pcolor(r,pres(:,:),ewq(sdeep,:)),shading flat;
axis ij
caxislim={[-2 2], [-0.4 0.4], [-1 1]} ;
caxis(caxislim{f});
colormap(brewermap(50,'*RdBu'));
ax = gca;
set(ax,'Xtick',[-200:20:200]);
set(ax,'Ytick',[0:100:1500]);
ylim([0 1500])
set(ax,'xaxisLocation','top')
ylabel(ax,'Pressure (dbar)','FontSize',10)
xlabel(ax,'Radius (km)','FontSize',10)
c=colorbar;
%
varc={'\deltatemp', '\deltasal', '\delta\rho'};
unitc={'(°C)','(psu)', '(kg/m^3)'} ;
%title(c,{'\delta\rho';'(kg/m^3)'})
title(c,{varc{f};unitc{f}})
hold all
v = {[-3:0.2:3], [-0.4:0.02:0.4], [-1:0.05:1] };
v{f}(find(v{1,f}==0))=[];
[C, hT]=contour(r,pres,ewq(sdeep,:),v{f},'k');
set(hT,'LineWidth',0.5,'Color','k','linestyle','-');
clabel(C,hT,v{f},'LabelSpacing',100,'Fontsize',7);    
set(ax,'linewidth',1)
set(ax,'layer','top')
axis square
titlefield={'Temperature Anomaly', 'Salinity Anomaly', 'Density Anomaly'};
title(titlefield{f})

if figmld 
line(get(ax,'Xlim'),[avemld avemld],'color','k','linestyle','-','linewidth',1.5)
% line(get(ax,'Xlim'),[maxmld maxmld],'color','k','linestyle','--','linewidth',1.5)
end

if flagfig2
saveas(gcf,namefig2)
end

end


end
end
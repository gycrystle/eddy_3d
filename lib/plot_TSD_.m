% Plot Temperature Salinity Density profile
%
fs=12
field = {'temp','sal','rho'}
xlabeL = {'Temperature (^oC)','Salinity (psu)','Density \rho (kg/m^3)' }
xlabeLm = {'mean T(^oC)','mean sal(psu)','mean \rho (kg/m^3)'}
xlabeLrms = {'rms T(^oC)','rms sal(psu)','rms \rho (kg/m^3)'}
Lims  = {[10:0.5:25],[38.6:0.1:39.2],[1027:.1:1029.5]}
xLims = {[13 24],[38.7 39.2],[1027 1030]}
rmsLims  = {[0 4],[0 0.3],[0 1]}


for f = 1:length(field)

if f ==1   
   varout =    Ptempout;     varin =    Ptempin;
  mvarout =   mPtempout;    mvarin =   mPtempin;
rmsvarout = rmsPtempout;  rmsvarin = rmsPtempin;
  
elseif f ==2
   varout   = Psalout;        varin = Psalin;
  mvarout   = mPsalout;      mvarin = mPsalin;
rmsvarout = rmsPsalout;    rmsvarin = rmsPsalin;
  
elseif f ==3
   varout =   Prhoout;        varin =    Prhoin;
  mvarout =  mPrhoout;       mvarin =   mPrhoin;
rmsvarout = rmsPrhoout  ;  rmsvarin = rmsPrhoin;      
end


hfig2 = figure(2)
s=subplot(1,3,f)
plot(mvarout,pres,'b','linewidth',2.5)
hold on
plot(mvarout+rmsvarout,pres,'b--','linewidth',0.5)
hold on
plot(mvarout-rmsvarout,pres,'b--','linewidth',0.5)
hold on
plot(mvarin,pres,'-','color',[0.5 0 0],'linewidth',2.5)
hold on
plot(mvarin+rmsvarin,pres,'-','color',[0.5 0 0],'linewidth',0.5)
hold on
plot(mvarin-rmsvarin,pres,'-','color',[0.5 0 0],'linewidth',0.5)
axis ij
ax = gca;grid on
xlabel(xlabeL{f},'Fontsize',fs,'Fontweight','bold')
set(ax,'xaxisLocation','top')
ylabel('Depth (dbar) ','Fontsize',fs,'Fontweight','bold')
ax.GridLineStyle = ':'
ax.GridColor = 'k';
ax.XMinorTick = 'on'
ax.YMinorTick = 'on'
% ax.XAxis.MinorTickValues = Lims{f};
% set(ax,'XAxisMinorTickValues',Lims{f})
% ax.YAxis.MinorTickValues = 0:100:2000;
ax.TickLength = [0.015, 0.015]
xlim(xLims{f})

end


%if flagfig 
hfig2name = ['E_',eddy,'_outerProfs_@rms']
print(hfig2,[path_output, hfig2name],'-dpng','-r300')
%end


clearvars -except l n level name path_io path_output no_param
% computer = 'D:/Documents'
% addpath(['',computer,'/MATLAB/matpalettes'])
% addpath(['',computer,'/IMED/ANALYSIS/MARGO/argofun'])

%LOAD FIELDS
field = {'tempA','salA','rhoA'};      fi = 3; 
disp(['----- Field: ',num2str(field{fi}), '-----'])

file_N=[path_io 'sortN.mat'];
load(file_N,'Nssal','Nsort_rad','pres')
  distance = Nsort_rad;
       var = Nssal;    

file_O=[path_io 'sortO.mat'];
load(file_O,'Ossal')
mPvar = nanmean(Ossal,2);
ref_varOut = repmat(mPvar,1,length(distance));
      varA = (var - ref_varOut);
       Z = pres(:,1);      
       
       
       
 for prmt = no_param;%:4      
% prompt = 'How many params?';
% stv = input(prompt,'s')  
% prmt = str2num(stv)


filesave = ['./fitvars/sortN_',num2str(field{fi}),'_fitparam',num2str(prmt),'.mat'];
load(filesave)

r = -100:1:100;
for deep = 1:400

       Input = real(lsqFit(deep,:));
Lewq(deep,:) = funFit(Input,r);
  
end
ewq = real(Lewq);


hfig = figure;
pcolor(r,pres,ewq),shading flat
axis ij
caxis([-1 1])
colormap(brewermap(50,'*RdBu'))
ax = gca;
set(ax,'Xtick',[-200:20:200])
set(ax,'Ytick',[0:100:1500])
ylim([0 1500])
set(ax,'xaxisLocation','top')
ylabel(ax,'Pressure (dbar)','FontSize',10)
xlabel(ax,'Radius (km)','FontSize',10)
c=colorbar;
title(c,{'\delta\rho';'(kg/m^3)'})
hold all
v = [-1:0.05:1]; 
v(v==0) = [];
[C, hT]=contour(r,pres,ewq,v,'k');
set(hT,'LineWidth',0.5,'Color','k','linestyle','-');
clabel(C,hT,v,'LabelSpacing',100,'Fontsize',7)    
set(ax,'linewidth',1)
set(ax,'layer','top')
axis square
saveas(gcf,[path_output, 'Rho_anom',num2str(prmt),'.png'])




%Thermal Wind try 
%...........................
omega = 2 * pi / (60 * 60 * 24); %         earth rotation
g     = 9.81;                    % (m/s2)  acceleration of gravity
rho0  = 1029;                    % (kg/m3) reference density
lat   = 33.5840;                 % lat of the eddy
f     = 2*omega.*sind(lat);      % coriolis parameter in lat
% f = 1e-4;

sdeep  = 1:201;
DrhoA   = ewq(sdeep,:);
Dprs   = repmat(pres(sdeep),1,length(r));
Drad   = repmat(r,sdeep(end),1);


% GEO
%.................
fdr   = gradient(Drad)*1000;
fdden = gradient(DrhoA);
fdz   = gradient(Dprs')';

fdv   = -g/(rho0*f)  .*  (fdden./fdr)  .*fdz;
fdv (isnan(fdv)) = 0;

levels = 10:200;
fdvv = fdv(levels,:);
vel  = cumsum(fdvv(end:-1:1,:),1);
velG = flipud(vel);



v = [-.5:0.05:0.5]*100;
v(v==0)=[];
figure,hold all
% pcolor(Drad(levels,:),Dprs(levels,:),velG*100),shading flat
% hold on
% axis ij
[C, hT]=contourf(Drad(levels,:),Dprs(levels,:),velG*100,v,'k');
set(hT,'LineWidth',0.5,'Color','k','linestyle','-');
clabel(C,hT,v,'LabelSpacing',1000,'Fontsize',10)    
caxis([-60 60])
c=colorbar;
title(c,{'V','(cm/s)'})
colormap(flipud(brewermap(40,'RdBu')));
ylim([0 1050])
line(get(gca,'Xlim'),[0 0],'Color','k')
line([0 0],get(gca,'Ylim'),'Color','k')
ax=gca;
set(ax,'xaxisLocation','top')
ylabel(ax,'Pressure (dbar)','FontSize',10)
xlabel(ax,'Radius (km)','FontSize',10)
axis ij
hold on
t = title({'Geostrophic Velocity';''});
saveas(gcf,[path_output, 'Vgeo_param',num2str(prmt),'.png'])


% CUCLOGEO
%.................
k = sdeep(end);
IIv0 = zeros(1,length(Drad)-1);
  vvC(:,:) = zeros(k,length(Drad)-1);
for k = sdeep(end-1):-1:sdeep(4)
    
    IIrho =  DrhoA(k,2:end)-DrhoA(k,1:end-1);
    IIr   =  (Drad(k,2:end)-Drad(k,1:end-1))*1000;
    IIz   =  Dprs(k,2:end)-Dprs(k-1,1:end-1);
    IId(k,:)   =  -g/(rho0) * (IIrho./IIr).*IIz;
  

end

for k = sdeep(end-1):-1:sdeep(4)

    for i = 1:101
           a = -1./(r(i)*1000);
           b = f;
           c = -IId(k,i);
           x= rqe2(a,b,c);

            riza1(k,i) = x(1);
            riza2(k,i) = x(2);
    end
    
    for i = 102:length(Drad)-1
           a = 1./(r(i)*1000);
           b = f;
           c = -IId(k,i);
           x= rqe2(a,b,c);

            riza1(k,i) = x(1);
            riza2(k,i) = x(2);
    end
    
 
    
end

deltaV = real(riza1);

Iv0 = zeros(1,length(Drad)-1);
for k = sdeep(end-1):-1:sdeep(4)

    Ivd  = deltaV(k,:);
    Iv1  =  Ivd + Iv0; 

    vvC(k,:) = Iv1;
    Iv0 = Iv1;     
end

velC = vvC;


figure
[C, hT]=contourf(Drad(:,1:end-1),Dprs(:,1:end-1),velC*100,v,'k');
set(hT,'LineWidth',0.5,'Color','k','linestyle','-');
clabel(C,hT,v,'LabelSpacing',1000,'Fontsize',10)    
caxis([-60 60])
c=colorbar;
title(c,{'V','(cm/s)'})
colormap(flipud(brewermap(40,'RdBu')));
ylim([0 1050])
line(get(gca,'Xlim'),[0 0],'Color','k')
line([0 0],get(gca,'Ylim'),'Color','k')
ax=gca;
set(ax,'xaxisLocation','top')
ylabel(ax,'Pressure (dbar)','FontSize',10)
xlabel(ax,'Radius (km)','FontSize',10)
axis ij
hold on
title({'Cyclogeostrophic Velocity';''})
saveas(gcf,[path_output, 'Vcuclogeo_param',num2str(prmt),'.png'])


crofig=figure('visible','off');
zl = 20;
f1 = plot(Drad(zl,1:end-1),velC(zl,:)*100,'color',[0.5 0 0],'linewidth',0.5);
hold on
f2 = plot(Drad(zl,1:end-1),velG(zl,1:end-1)*100,'color','k','linewidth',0.5);
legend([f1 f2],'Cyclo V','Geo V')
ylim([-50 50])
saveas(crofig,[path_output, 'Vcgsection_param',num2str(prmt),'.png'])
close(crofig)


filenameS = [path_output, 'vel_param',num2str(prmt),'.mat'];
save(filenameS,'velG','velC')



 end


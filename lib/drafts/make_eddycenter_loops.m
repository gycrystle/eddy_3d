clearvars -except path* eddy*
%spread=843:934; %20 sep- 19 dec for analyzing 10 oct - 30 nov
spread=835:942; %trying longer period for analyzing 10 oct - 30 nov
%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';
%
%addpath(['',computer,'/m_map']);
addpath(['',computer,'/matfun']);
addpath(['',computer,'/matpalettes']);
%addpath(['',computer,'/seawater']);
%addpath(genpath(['',computer,'/mixing_library']))
addpath(['',computer,'/bathy']);
%path_argo = ['',computer,'/MARGO/'];
%addpath([path_argo 'argofun/']);
path_io = ['',computer,'eddy3D/io/'];
path_lib =['',computer,'eddy3D/lib/'];


load([path_io,'data_perargo11.mat'])
col = {[0.7 0 0 ],'k',[0 0.5 0],'b'};
lys = {'-','--','--','-'};
dayi = [2015 06 01 12 0 0];

timelims = spread(1);
timelime = spread(end);
stepFs = timelime-timelims+1;
%spread = timelims:timelime;

openlocalmax = 1;
figure 
for a = [1 4]

lona = lon(:,a);
lata = lat(:,a);

        subplot(2,1,1)
        hold all
        p  = plot(datenum(time),lona,'o','Color',col{a},...
                                 'MarkerEdgeColor','k',...
                                 'MarkerFaceColor',col{a},...
                                 'MarkerSize',5,...
                                 'linewidth',0.3,'linestyle',lys{a});
        hold on                    
        subplot(2,1,2)
        p4 =  plot(datenum(time),lata,'o','Color',col{a},...
                                 'MarkerEdgeColor','k',...
                                 'MarkerFaceColor',col{a},...
                                 'MarkerSize',5,...
                                 'linewidth',0.3,'linestyle',lys{a});   

        hold on
        
        if openlocalmax == 1
        [latmaxima, imaxlat]= findpeaks(lata);
        [latminima, iminlat]= findpeaks(-lata);

        [lonmaxima, imaxlon]= findpeaks(lona);
        [lonminima, iminlon]= findpeaks(-lona);
        
        subplot(2,1,1)
        plot(datenum(time(imaxlon,:)),lona(imaxlon),'o','Color','k',...
                                 'MarkerFaceColor',rgb('Yellow'),...
                                 'MarkerSize',5);    
        plot(datenum(time(iminlon,:)),lon(iminlon),'o','Color','k',...
                                 'MarkerFaceColor',rgb('Yellow'),...
                                 'MarkerSize',5);  
                             
        subplot(2,1,2)                     
        plot(datenum(time(imaxlat,:)),lat(imaxlat),'o','Color','k',...
                                 'MarkerFaceColor',rgb('Yellow'),...
                                 'MarkerSize',5);  
        plot(datenum(time(iminlat,:)),lat(iminlat),'o','Color','k',...
                                 'MarkerFaceColor',rgb('Yellow'),...
                                 'MarkerSize',5);  
                             
        eval(['lon',num2str(a),'  = lona;'])  
        eval(['lat',num2str(a),'  = lata;'])  
                             
        eval(['latmaxima',num2str(a),'  = latmaxima;'])   
        eval(['latmaxima',num2str(a),'  = latminima;']) 
        eval(['lonmaxima',num2str(a),'  = lonmaxima;']) 
        eval(['lonminima',num2str(a),'  = lonminima;']) 
        
        
        eval(['imaxlat',num2str(a),'  = imaxlat;'])   
        eval(['iminlat',num2str(a),'  = iminlat;']) 
        eval(['imaxlon',num2str(a),'  = imaxlon;']) 
        eval(['iminlon',num2str(a),'  = iminlon;'])  
                             
        end

end

%Figure details
for s = 1:2
subplot(2,1,s)                     
ax=gca;
sts= 3;
xlim([datenum(time(timelims,:)) datenum(time(timelime,:))])
set(gca,'XTick',datenum(time(timelims:sts:timelime,:)) ) 
set(gca,'XTicklabel',datestr(time(timelims:sts:timelime,:),'dd-mmm'),'Fontsize',7)
ax.XTickLabelRotation=90;
grid on;box on
end

                     
%%combine min and max and combine argos
% lon lat not same length so i had to do something eliminate first(2:end)
% or add more lon before 
  imaxlon1 = [imaxlon1];
  imaxlat1 = [imaxlat1];

imllat_nonsort1  = [iminlat1;imaxlat1];
imllon_nonsort1  = [iminlon1;imaxlon1];

    [imllat1] = sort(imllat_nonsort1);
    [imllon1] = sort(imllon_nonsort1);

imllat_nonsort4  = [iminlat4;imaxlat4];
imllon_nonsort4  = [iminlon4;imaxlon4];

    [imllat4] = sort(imllat_nonsort4);
    [imllon4] = sort(imllon_nonsort4);
    
 

    length(iminlat1);
    length(imaxlat1);
    length(iminlon1) ;
    length(imaxlon1) ;
        length(imllon1) ;
        length(imllat1) ;
    
    length(iminlat4);
    length(imaxlat4);
    length(iminlon4) ;
    length(imaxlon4)   ;
        length(imllon4) ;
        length(imllat4) ;
    
        
%%%Find mean position between max min of loops   
%Argo1
imllat1 ;
imllon1;
imllat4;
imllon4;

subplot(2,1,1)

k = 0;
for j = 1:length(imllon1)-1
k = k+1;
spread = imllon1(j):imllon1(j+1);
targo(k) = round(median(spread));
xargo(k) = nanmean(lon1(spread)) ;
xxargo(spread) = xargo(k);
end  

plot(datenum(time(targo,:)),xargo,'o','Color','k',...
                         'MarkerFaceColor',[0.75 0.75 0],...
                         'MarkerSize',8);  
                     hold on


subplot(2,1,2)

k = 0;
for j = 1:length(imllat1)-1
k = k+1;
spread = imllat1(j):imllat1(j+1);
targo(k) = round(median(spread));
yargo(k) = mean(lat1(spread)) ;
yyargo(spread) = yargo(k);
end  

plot(datenum(time(targo(1:end-1),:)),yargo,'o','Color','k',...
                         'MarkerFaceColor',[0.75 0.75 0],...
                         'MarkerSize',8);  
                     hold on

% %Argo4
% subplot(2,1,1)
% k = 0;
% for j = 1:length(imllon4)-1
% k = k+1;
% %spread = imllon4(j):imllon4(j+1);
% targo4(k) = round(median(spread))+1
% xargo4(k) = mean(lon4(spread)) ;
% xxargo(spread) = xargo4(k);
% end  
% 
% plot(datenum(time(targo4,:)),xargo4,'o','Color','k',...
%                          'MarkerFaceColor',[0 0.5 0.5],...
%                          'MarkerSize',8);  
%                      hold on
%                     
% 
% subplot(2,1,2)
% 
% k = 0;
% for j = 1:length(imllat4)-1
% k = k+1;
% %spread = imllat4(j):imllat4(j+1);
% targo4(k) = round(median(spread))+1;
% yargo4(k) = mean(lat4(spread)) ;
% yyargo(spread) = yargo4(k);
% end  
% 
% plot(datenum(time(targo4(1:end-1),:)),yargo4,'o','Color','k',...
%                          'MarkerFaceColor',[0 0.5 0.5],...
%                          'MarkerSize',8);  
%                      hold on

                     
% for p = 1:length(targo4)    
%     
%     targo4(p)
%     
%     for k = 1:length(time)    
% 
%         if  datenum(time(targo4(p),:)) == datenum(time(k,:))
% 
%             k;
%             Targo4(p) = k;
%         end
%     end
%     
%     
%     
% end   
           



%% Fit line between all the points
tfitargo = [timelims targo];%spread(1:end-1);%
xfitargo = [lon1(timelims) xargo]   ;
yfitargo = [lat1(timelims) yargo] ; 
 

fittedX = linspace(datenum(time(timelims,:)),datenum(time(timelime,:)),stepFs);
fitTime  = fittedX;

subplot(2,1,1)

fittedY = interp1(datenum(time(tfitargo,:)),xfitargo',fittedX,'linear');
% Plot the fitted line
hold on;
fx =plot(fittedX, fittedY, '-','Color',[0.75 0.75 0], 'LineWidth', 3);
fitxargo = fittedY;
fittargo = fittedX;
%%%.................

%ylim([25.2 26.4])

subplot(2,1,2)
clear fittedY
fittedY = interp1(datenum(time(tfitargo(1:end-1),:)),yfitargo',fittedX,'spline');
% Plot the fitted line
hold on;
fy = plot(fittedX, fittedY, '-','Color',[0.75 0.75 0], 'LineWidth', 3);
fityargo = fittedY;
%%%.................
%ylim([33.5 34.4])


delete(fx)
delete(fy)

%Smooth if needed
wfitxargo = smooth(fitxargo,7);
wfityargo = smooth(fityargo,7);

subplot(2,1,1)
plot(fitTime,wfitxargo, '-','Color',[0.75 0.75 0], 'LineWidth', 3);
subplot(2,1,2)
plot(fitTime,wfityargo, '-','Color',[0.75 0.75 0], 'LineWidth', 3);

                     
save eddycenter_loops.mat fitxargo fityargo fittargo wfitxargo wfityargo


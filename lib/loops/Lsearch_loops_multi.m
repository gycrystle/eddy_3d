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

h_coast=1;if h_coast; coast=csvread('bathy/new_bathy.csv');end
    minlat = 32.2;                                                      
    maxlat = 34.5;                                                       
    minlon = 27;                                                        
    maxlon = 30.5;  
m_proj('Mercator','lat',[minlat maxlat],'lon',[minlon maxlon]);

%Load argo
%................................
% IMS METU - Middle East Technical University - Institute of Marine Sciences - Turkey
% OGS  - Pierre-Marie POULAIN - Istituto Nazionale di Oceanografia e di Geofisica Sperimentale 
% HCMR - Hellenic Centre for Marine Research, Institute of Oceanography - Greece
% LOV  - Laboratoire Oceanographique de Villefranche - France - 6901770 &6901764
% NAVO - Naval Oceanographic Office 
path_argo = ['',computer,'/Documents/IMED/ANALYSIS/MARGO/Argos_/argos/'];

    name  = {'6902770','3901853','6903204','6900422'};%,'6903276','6901764'}
    info  = {'SHOM','IMS METU','OGS','NAVO','HCMR','LOV'};%,'LOV'}
    col   = {[0.7 0 0 ],'k',[0 0.5 0],'b',rgb('DimGray'),rgb('DarkBlue'),rgb('DarkBlue')};
    facol = {'w','k',[0 0.5 0],'w','w','w',rgb('DimGray')};
    mark  = {'o','d','o','o','o','d','d'}; 

flagsave = 1
load([path_io, 'sortI.mat'])
npres = pres;
load([path_io, 'data_perargo11.mat'])
load([path_io, 'ref_pro.mat']) 

%well defined loops
loop_pstart=[ ...
    %2017,10,5; ...
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
loop_pend=[ ...
    %2017,10,19; ...
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
pstart=zeros(size(loop_pstart,1),1);
pend=pstart;
for i = 1:size(loop_pstart,1)
    
spread  =[];
pstart(i)=find(time(:,1)==loop_pstart(i,1) & time(:,2)==loop_pstart(i,2) & time(:,3)==loop_pstart(i,3));
pend(i)=find(time(:,1)==loop_pend(i,1) & time(:,2)==loop_pend(i,2) & time(:,3)==loop_pend(i,3));
spread = pstart(i):pend(i); %find(   lap{l}


yy = nan(size(spread,2),2);
xx = nan(size(spread,2),2);
k =0;
for j = 1;%[1 4]%:length(name)
    k = k+1

    x = lon(spread,j);
    y = lat(spread,j);
   
    yy =  y(~isnan(y));
    xx =  x(~isnan(x));
    
    eval(['xx',num2str(k),'=xx;'])
    eval(['yy',num2str(k),'=yy;'])    
end

figure
plot(xx1,yy1,'ko-')
for p = 1:length(xx1)
   text(xx1(p),yy1(p),num2str(p)) 
end
hold on
% plot(xx2,yy2,'ko-')
% hold on


grid_ll = 1;
[R1,A1,P1,ll1] = mean_radius([xx1';yy1'],grid_ll); 
[xbary1,ybary1,z1,a1,b1,alpha1,lim,coord] = compute_ellipT([xx1';yy1'],0);
[ellip1] = ellipticity(a1,b1)
    
figure
plot(xx1,yy1,'ko-')
hold on
[el, X1] = plotellipseT(z1,a1,b1,alpha1, '-');

elon1 = X1(1,:);
elat1 = X1(2,:);
[eR1,eA1,eP1,ell1] = mean_radius([elon1;elat1],grid_ll); 
hold on




% grid_ll = 1;
% [R2,A2,P2,ll2] = mean_radius([xx2';yy2'],grid_ll); 
% [xbary2,ybary2,z2,a2,b2,alpha2,lim,coord2] = compute_ellipT([xx2';yy2'],0);
%[ellip2] = ellipticity(a2,b2)
    

% [el X2] = plotellipseT(z2,a2,b2,alpha2, '-')
% elon2 = X2(1,:);
% elat2 = X2(2,:);
% [eR2,eA2,eP2,ell2] = mean_radius([elon2;elat2],grid_ll); 



close all
exbary1 = mean(elon1);
eybary1 = mean(elat1);

% exbary2 = mean(elon2);
% eybary2 = mean(elat2);


figure
hold all
for j = 1%:4
    
    xar = lon(spread,j);
    yar = lat(spread,j);
    yargo =  yar(~isnan(yar));
    xargo =  xar(~isnan(xar));
    
    hold on
    m_plot(xargo,yargo,mark{j},'color',col{j},...
    'MarkerFaceColor',facol{j},...
    'MarkerSize',6,...
    'linewidth',0.3,'linestyle','--');  
hold on
end
if h_coast
    [X,~]=m_ll2xy(coast(:,1),coast(:,2),'clip','patch');
    k=find(isnan(X(:,1)));
    for pp=1:length(k)-1,
        xc=coast([k(pp)+1:(k(pp+1)-1) k(pp)+1],1);
        yc=coast([k(pp)+1:(k(pp+1)-1) k(pp)+1],2);
        m_patch(xc,yc,[.9 .9 .9]);
    end
else
    m_coast('color','k');
end   
m_grid('tickdir','in','xtick',4,'ytick',4,'linewidth',1,'Fontsize',14); 
ax1= gca;
axes(ax1)
dste = ['',datestr(time(spread(1),:),'dd/mmm'),'--',datestr(time(spread(end),:),'dd/mmm'),''];
t = title(dste);
set(t, 'horizontalAlignment', 'left')
set(t, 'units', 'normalized')
h1 = get(t, 'position');
set(t, 'position', [h1(3) h1(2) 1])
m_plot(exbary1,eybary1,'+','color',col{1},'linewidth',0.3,'linestyle','-'); 
%m_plot(exbary2,eybary2,'+','color',col{4},'linewidth',0.3,'linestyle','-'); 
m_plot(elon1,elat1,'-','color',col{1},'linewidth',0.3,'linestyle','-'); 
%m_plot(elon2,elat2,'-','color',col{4},'linewidth',0.3,'linestyle','-'); 


nameFIG = ['loop_',num2str(i),'_',datestr(time(spread(1),:),'dd-mmm'),'_',datestr(time(spread(end),:),'dd-mmm'),''];
if flagsave ==1
print(gcf,nameFIG,'-dpng','-r150')
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear radius

        for j = 1%:4
            xar = lon(spread,j);
            yar = lat(spread,j);
            yargo =  yar(~isnan(yar));
            xargo =  xar(~isnan(xar));

            Texbary = nanmean([exbary1]);%;exbary2
            Teybary = nanmean([eybary1]);%;eybary2

            for kk= 1:length(xargo)
            xs=[];
            ys=[];
            xs = [Texbary  xargo(kk)];
            ys = [Teybary  yargo(kk)] ;   
            [radius(kk,j) angle(kk,j)]= sw_dist(ys,xs,'km');

            end
        end
radius(radius==0)=nan;   

loopTSP(i).spread = spread;
loopTSP(i).radius = radius;
figure
subplot(132)
         counter = 0
        for ii = spread
            counter = counter+1
            for j = 1:length(name)
                
                
            loopTSP(i).pres{counter,j} = pres{ii,j} ;  
            loopTSP(i).temp{counter,j} = temp{ii,j};
            loopTSP(i).sal{counter,j} = sal{ii,j};
            loopTSP(i).rho{counter,j} = rho{ii,j};
            loopTSP(i).lon(counter,j) = lon(ii,j);
            loopTSP(i).lat(counter,j) = lat(ii,j);
            
            plot(temp{ii,j},pres{ii,j},'color',col{j})
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
            xlabel('Temperature (^oC)')
        subplot(133)
        for ii = spread
            for j = 1:length(name)
            plot(rho{ii,j},pres{ii,j},'color',col{j})
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%record variables for every loop (continued..)
loop(i).step  = spread ;     
loop(i).timeS  = time(spread(1),:) ;     
loop(i).timeE  = time(spread(end),:) ;   

    for float = 1;%:2

    %initialize vars
          xx   = [];
          yy   = [];
          ell  = [];
          elat = [];
          elon = [];
        exbary = [];
        eybary = [];
             a = [];
             b = [];
             z = [];
         alpha = [];
         ellip = [];
            eR = [];
            eA = [];
            eP = [];


        eval([' xx = xx',num2str(float),';  '])
        eval([' yy = yy',num2str(float),';  '])
        eval([' ell = ell',num2str(float),';  '])
        eval([' elon = elon',num2str(float),';  '])
        eval([' elat = elat',num2str(float),';  '])
        eval([' exbary = exbary',num2str(float),';  '])
        eval([' eybary = eybary',num2str(float),';  '])
        eval([' a = a',num2str(float),';  ']) 
        eval([' b  = b',num2str(float),';  ']) 
        eval([' z  = z',num2str(float),';  '])
        eval([' alpha = alpha',num2str(float),';  '])
        eval([' ellip = ellip',num2str(float),';  '])
        eval([' eR =  eR',num2str(float),';  '])
        eval([' eA = eA',num2str(float),';  '])
        eval([' eP = eP',num2str(float),';  ']) 



            loop(i).lon{float,1}  = xx;
            loop(i).lat{float,1}  = yy;
            loop(i).elon{float,1}  = elon;
            loop(i).elat{float,1}  = elat;
            loop(i).exbary(float,1) = exbary;
            loop(i).eybary(float,1) = eybary;
            loop(i).ea(float,1)  = a;
            loop(i).eb(float,1)  = b;
            %loop(i).ez{float)  = z;
            loop(i).alpha(float,1)  = alpha;
            loop(i).ellip(float,1)  = ellip; 
            loop(i).ermax(float,1)   = eR(1);
            loop(i).earea(float,1)   = eA;   
            loop(i).ephery(float,1) = eP;


                 looptime = time(spread,:);
                      dif = looptime(1,:)-looptime(end,:);
                  seconds = etime(looptime(end,:),looptime(1,:));
                      T   = seconds/60/60/24;  %[days]   ;
             [turn,angle] = turn_angle([xx';yy'],grid_ll);
                   period = T/turn;     
                   velmax = eP*1000 ./(period*24*60*60); %[m/s]

         [distance,angle] = distp(ell,[elon;elat],grid_ll);
                      var = (distance - repmat(eR(1),1,length(distance)))';        
                     dim = 1;
                     siz = size(var,dim);
                 meanvar = nanmean(var,dim);
                 mvar    = repmat(meanvar,siz,1);
                    x_xm = (var-mvar).^2;
                  rmsvar = sqrt(nanmean(x_xm,dim)); 

            loop(i).Tloop(float,1) = T; 
            loop(i).period{float,1}  = period;
            loop(i).evmax(float,1)   = velmax;      
            loop(i).rmsrmax(float,1) = rmsvar;


    end

end

filename = ['loop.mat'];
save(filename,'loop','loopTSP')

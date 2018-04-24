clear all;clc;close all
computer ='/home/cgreace/tuto1/';% '~';

%Load argo
%................................
%path_argo = ['',computer,'/Documents/IMED/ANALYSIS/MARGO/argos/']
path_argo = ['',computer,'/MARGO/'];
path_input = ['',computer,'eddy3D/input/']
path_io = ['',computer,'eddy3D/io/']
name = {'6902770'};%,'3901853','6903204','6900422','6903276','6901764'}
for a = 1:length(name)
eval(['load([path_input, ''argo_',num2str(name{a}),'.mat''])'])
    eval(['lon',num2str(a),' =lon;'])
    eval(['lat',num2str(a),' =lat;'])
    eval(['time',num2str(a),'=time;'])
    eval(['pres',num2str(a),'=mpres;'])
    eval(['temp',num2str(a),'=mtemp;'])
    eval(['sal',num2str(a),' =msal;'])
    eval(['rho',num2str(a),' =mrho;'])
    clear lon lat time mpres mtemp msal mrho
end

% Initialize Time
% =============================================================
startyear = 2017;
startdate = datenum(sprintf('31-dec-%d',startyear-1));
datestr(startdate, 'dd-mmm-yyyy'); 

period = 420
for step = 1:period
     countdate= addtodate(startdate, step, 'day');
     date = datestr(countdate,'dd-mmm-yyyy')
     ndate = datenum(date)
     
     time(step,:) = datevec(date)
     
  for a = 1:length(name)
     
     eval(['ntime',num2str(a),' = round(datenum(time',num2str(a),'))'])
     eval(['ind',num2str(a),' = find(ntime',num2str(a),'== ndate)'])
     eval(['var = ind',num2str(a),';'])    
     if isempty(var)
        eval(['index',num2str(a),'(step,1)= 0;'])    
     else
        eval(['index',num2str(a),'(step,1)= 1;'])    
     end 
     
  end

end

 for a = 1:length(name)
     
    eval(['argoll',num2str(a),'= nan(period,2);'])
     eval(['atime',num2str(a),'= nan(period,6);'])
     eval(['apres',num2str(a),'= nan(max(size(pres',num2str(a),')),period);'])
     eval(['atemp',num2str(a),'= nan(max(size(temp',num2str(a),')),period);'])
      eval(['asal',num2str(a),'= nan(max(size(sal',num2str(a),')),period);'])
      eval(['arho',num2str(a),'= nan(max(size(rho',num2str(a),')),period);'])
 end

for a = 1:length(name)
  k = 1; 
   eval(['var = index',num2str(a),';'])    
   
    for i = 1:period

         if var(i) == 1
         
         eval(['argoll',num2str(a),'(i,1) = lon',num2str(a),'(k);'])
         eval(['argoll',num2str(a),'(i,2) = lat',num2str(a),'(k);'])
         eval(['atime',num2str(a),'(i,:) = time',num2str(a),'(k,:);'])
         eval(['apres',num2str(a),'(:,i) = pres',num2str(a),'(:,k);'])
         eval(['atemp',num2str(a),'(:,i) = temp',num2str(a),'(:,k);'])
         eval(['asal',num2str(a),'(:,i) = sal',num2str(a),'(:,k);'])
         eval(['arho',num2str(a),'(:,i) = rho',num2str(a),'(:,k);'])
         k = k+1
         end 
     
     end
      
end


save ([path_io, 'sychro_argoll_mm.mat'], 'time', 'argoll*', 'atime*', 'apres*', 'atemp*', 'asal*', 'arho*')

%                    
%  for p = 4:length(argoll1)-3
%    plot(argoll1(p-2:p+2,1),argoll1(p-2:p+2,2),'go-') 
%    hold on
%    xlim([24 30.5])
%    ylim([30 37.5])
%    plot(argoll2(p,1),argoll2(p,2),'ko-') 
%    hold on
%    plot(argoll3(p,1),argoll3(p,2),'bo-') 
%     hold on
%    plot(argoll4(p,1),argoll4(p,2),'bo-') 
%        hold on
%    plot(argoll5(p,1),argoll5(p,2),'mo-')
%    pause(0.01)
%    hold on
% 
%    hold off
% end                                              

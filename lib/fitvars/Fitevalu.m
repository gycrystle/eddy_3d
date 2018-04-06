clearvars -except l n level name
clc;close all
% computer = '~/Documents';
% addpath(['',computer,'/MATLAB/matpalettes'])
% path_argo = ['',computer,'/IMED/ANALYSIS/MARGO/'];
% addpath([path_argo 'argofun/'])

%Load Fields
field = {'tempA','salA','rhoA'};    f = 3; 
disp(['----- Field: ',num2str(field{f}), '-----'])
load('../../io/sortN.mat','pres')

% Start the evaluation
sdeep = 1:400
pres  = pres(sdeep,1);

param = 3   

filesave = ['sortN_',num2str(field{f}),'_fitparam',num2str(param),'.mat'];
load(filesave,'funFit','lsqFit','distance','varA')

    for deep = sdeep
    x = distance';
    y = varA(deep,:);
           Input = real(lsqFit(deep,:));
    Lewq(deep,:) = funFit(Input,x);

    end

eval(['varF',num2str(param),'= Lewq;'])
clear Lewq
    

varF = eval(['varF',num2str(param),';']);
varD = varF-varA;



%Compute RMS between varA and fitted varF
spread = 20:160
pres(spread(1)),pres(spread(end))

 dDi3d = varD(spread,:);
    dr = distance';
  Msum = nansum(dDi3d,1);
  Mave = nanmean(dDi3d,1);
  Mstd = nanstd(dDi3d,1);
lenan = dr(isnan(dr));

x_xm = (dDi3d).^2;
           
RMSr  = sqrt(nanmean(x_xm,1));  
RMSz  = sqrt(nanmean(x_xm,2));  

save evalu.mat dr dDi3d Mstd Msum Mave pres spread RMSr RMSz varF varA
 


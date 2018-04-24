%%
clear all; clc; close all;
%
%

%% General parameters
%----------------------------------------------
clearvars
% Argo info
name = {'6902770','3901853','6903204','6900422','6903276','6901764', ...
    '6901770',  '6901766', '6901845', '6903176','6901773'};%
%name  = {'6902770','3901853','6903204','6900422','6903276','6901764'}%,'6901770'};
info  = {'SHOM','IMS METU','OGS','NAVO','HCMR','LOV','??', '??', '??', '??','??'};
%
%
% Choose Period to analyse
tmin=[2017,10,10];
tmax=[2018,1,14];
%
argonumber = 11;
argo_id=1;
% I choose the period (spread) based on if the argo is in the assumed
% location of eddy, could use maybe radius instead of small square but
% since the shape of eddy could be ellips, square seemed more like a
% simpler option. 
eddy_id=1; % 1 for Mersa Matruh, 2 for Ierapetra
if eddy_id==1
    %%% Mersa matruh
    eddy = 'MM';
    eddy_lon=[28.2, 29.4]; %set the geographical limit of eddy   
    eddy_lat=[32.7, 33.65]; %values from manually checking the eddy trajectory
elseif eddy_id==2
    %%% Ierapetra
    eddy = 'IE';
    eddy_lon=[25.1, 26.3]; %set the geographical limit of eddy   
    eddy_lat=[33.4, 34.4]; %values from manually checking the eddy trajectory  
else
    %domain
    eddy = 'MM';
    eddy_lon=[28, 30]; %set the geographical limit of eddy   
    eddy_lat=[33, 34]; %values from manually checking the eddy trajectory
end
%
%-----------------------------------------------
% define eddy center
                    % 1:fixed argo 
eddy_center=1;      % 2:Fixed Aviso 
                    % 3:Moving argo 
                    % 4:Looping
                    %
% Choose a radius that assumed to be the radius of eddy
% All the profiles located within this radius from the choosen eddy center
% considered to be the profiles inside the eddy
mRad = 80;
mRad2=80;
% dst
% What else?
%
%%Paths
%Load directories & paths
% %................................
run(['./lib/paths.m']);
%
% Define synchronized argo dataset name
dataset=([path_io, '/data_perargo11.mat']);%'data_perargo10.mat'
%
%%Plotting options
% What to plot?
plot_allargo=0;
plot_reference=0;
plot_argomap=1;
plot_TSD=1;
plot_fit=1;
plot_anom_fit=1;
plot_V_g=1;
plot_V_cg=1;
% Boundaries for map plot
minlat = 31;                                                      
maxlat = 37;                                                       
minlon = 23;                                                        
maxlon = 33;
%
% Parameter for plotting
col   = {rgb('IndianRed'),rgb('DarkBlue'),rgb('Moccasin'),rgb('CornflowerBlue'),...
    rgb('PaleVioletRed'),rgb('Khaki'),rgb('LightSteelBlue'),rgb('PeachPuff'),...
    rgb('Orchid'),rgb('MediumAquamarine'),rgb('DimGray'),rgb('SeaGreen')};
facol = {rgb('IndianRed'),rgb('DarkBlue'),rgb('Moccasin'),rgb('CornflowerBlue'),...
    rgb('PaleVioletRed'),rgb('Khaki'),rgb('LightSteelBlue'),rgb('PeachPuff'),...
    rgb('Orchid'),rgb('MediumAquamarine'),rgb('DimGray'),rgb('SeaGreen')};
    %{'w','k',[0 0.5 0],'w','w','w',rgb('DimGray')};
mark  = {'o','d','o','d','o','d','o','d','o','d','o'}; 
%
%%
% %Plot all argo location
if plot_allargo==1
    run(['./lib/plot_all_argo.m']);
end
% %Plot reference
if plot_reference==1
    run(['./lib/plot_ref.m']);
end
%% Sorting
% Sort profiles based on distance from the center
%
% Load data
load(dataset);
%
% Sorting argo profile based on distance from center
% center is choosen either fix or moving
run(['./lib/sort_argo.m']);
%            
%% Fitting
%
%Fit the sorted profiles with gaussian function
%
% Number of fitting parameters 

% Initial values for fitting parameters
%    Ta0 = 0;
%      R0 = 40;
%  coef_0 = 1e-6;
% alpha_0 = 2;
% Input_0 = [Ta0,coef_0,R0,alpha_0];

% Limit for fitting coef
   Ta_limit = [-10, 10]; % maksimum anomaly of density or temperature or salinity
    R_limit = [30, 50];
 coef_limit = [1e-7, 1];
alpha_limit = [0, 10];
%
run([path_lib, 'fitting_anomaly.m']) 
%
% run([path_lib, '/fitvars/fit_rhoA_param2.m']) 
% run([path_lib, '/fitvars/fit_rhoA_param3.m']) 
% run([path_lib, '/fitvars/fit_rhoA_param4.m']) 
% run([path_lib, '/fitvars/fit_salA_param3.m']) 
% % run(['./lib/fitvars/fit_salA_param4.m']) 
% run([path_lib, '/fitvars/fit_tempA_param3.m']) 
% run(['./lib/fitvars/fit_tempA_param4.m']) 
%if plot_fit==1
%     run(['./lib/fitvars/xlevels_fields_param.m']) 
%end
if plot_fit==1
    run([path_lib, '/fitvars/xlevels_fields_param.m']) 
end
%
if plot_anom_fit==1
    run([path_lib, '/plot_fit_.m']) 
end
%%
% Calculate Geostrophic and Cyclogeostrophic Velocity from 
% density anomaly fit
% %
for no_param=2:3; % 3:fixed alpha; 4:All parameters fitted
%
run([path_lib, '/thermalW.m']) 
end


clear all;clc;close all
%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';
%
addpath(['',computer,'/m_map']);
addpath(['',computer,'/matfun']);
addpath(['',computer,'/matpalettes']);
addpath(['',computer,'/seawater']);
addpath(genpath(['',computer,'/mixing_library']))
addpath(['',computer,'/bathy']);
path_argo = ['',computer,'/MARGO/'];
addpath([path_argo 'argofun/']);
path_io = ['',computer,'eddy3D/io/']
path_lib =['',computer,'eddy3D/lib/']
%path_output = ['',computer,'/eddy3D/output/',num2str(eddy),'/',num2str(eddy_center),'/'];

% 
% computer = '~/Documents'%'~/Documents'
% addpath(['',computer,'/MATLAB/matpalettes'])
% addpath(['',computer,'/MATLAB/matfun'])
% addpath(['',computer,'/IMED/ANALYSIS/MARGO/argofun/'])
% % addpath(['',computer,'/MATLAB/AMEDA/'])
% addpath(['',computer,'/MATLAB/AMEDA/tools/'])
% addpath(genpath(['',computer,'/MATLAB/geom2D']))
% addpath(['',computer,'/MATLAB/bathy'])
h_coast=1;if h_coast; coast=csvread('bathy/new_bathy.csv');end
    minlat = 32.5;                                                      
    maxlat = 35.8;                                                       
    minlon = 23.5;                                                        
    maxlon = 28;      
latlim = [minlat maxlat];
lonlim = [minlon maxlon];

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


load('../../sychronizenew.mat')

j = 4
  
    
spread = 40:126
    tt =  time(spread,:);
    yy =  lat(spread,j);
    xx =  lon(spread,j);
    
    
drifter(j).date = datenum(tt)
drifter(j).lon  = xx;
drifter(j).lat  = yy;

name = ['drifter',num2str(j),'.mat']
save(name,'drifter')






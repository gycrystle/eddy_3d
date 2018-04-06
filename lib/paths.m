%%
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
path_output = ['',computer,'/eddy3D/output/',num2str(eddy),'/',num2str(eddy_center),'/'];

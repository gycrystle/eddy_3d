clearvars -except eddy* path* no_param *limit plot*;

%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';
%
path_io = ['',computer,'eddy3D/io/'];
warning off

flagplot = 0;
flagfig  = 0;

%First guess fitting parameters
     Ta0 = 0;
     R0 = 30;
 coef_0 = 1e-6;
alpha_0 = 2.0;
Input_0 = [Ta0,coef_0,R0,alpha_0];

%    Ta_limit = [-10, 10]; % maksimum anomaly of density or temperature or salinity
%     R_limit = [30, 80];
%  coef_limit = [1e7, 1];
% alpha_limit = [2, 10];

%LOAD FIELDS
field = {'tempA','salA','rhoA'};      
fields= {'temp','sal','rho'};
%load([path_io, 'sortI.mat']);
load([path_io, 'sortI_loop.mat']);
load([path_io, 'ref_pro.mat']);

distance = Isort_rad; %Nsort_rad;
Z = pres(:,1);

for f =1:3; 
disp(['----- Field: ',num2str(field{f}), '-----']);
eval(['var = Is',num2str(fields{f}),';']); %var = Isrho;    

%eval(['mPvar = autumn.m',num2str(fields{f}), ';']);  
eval(['mPvar_wi = winter.m',num2str(fields{f}), ';']);  
eval(['mPvar_sp = spring.m',num2str(fields{f}), ';']);  
eval(['mPvar_su = summer.m',num2str(fields{f}), ';']);  
eval(['mPvar_au = autumn.m',num2str(fields{f}), ';']);  
% eval(['var = Is',num2str(fields{f})]); 
% eval(['mPvar = autumn.m',num2str(fields{f})]);
%mPvar = autumn.mrho; %%% change the reference 

ref_varOut = repmat(mPvar_wi,1,length(distance));
      varA = (var - ref_varOut);
       
%FLAGS & names
filesave2 = [path_io, 'sortN_',num2str(field{f}),'_fitparam2.mat'];
               
%FITTING 


Anom=varA(:,1);
Anom(find(isnan(Anom))) =0; %set NaN values to 0

%Function & Method  
lsqOpts = optimoptions('lsqcurvefit',...
    'MaxFunEvals', 1e6, 'MaxIter', 1e4,'Display','off'); 

%START
for deep = 1:200
   
disp(['Depth: ',num2str(Z(deep)),'m -----'])

funFit2=@(Input,r)Anom(deep,1).*exp(-(1/real(Input(4))).*(abs(r).^real(Input(4)))...
    ./(real(Input(3))^real(Input(4))));

x = distance';
y = varA(deep,:);

    ind = find(isnan(y));
    x(ind) =[];
    y(ind) =[];

%    ind = find(x==0);
% x(ind) =[];
% y(ind) =[];

if  ~isempty(x)

    xx = [-x(end:-1:1),x];
    yy = [y(end:-1:1),y]; 

    
% Compute Fitting
% method (b)            
see(deep)=abs(min(yy))- abs(Input_0(1));

% [coef_lsqXY,resnorm,residual]=lsqcurvefit(funFit,Input_0,xx,yy);  

[coef_lsqXY,resnorm,residual]=lsqcurvefit(funFit2,Input_0,xx,yy,...
    [Ta_limit(1), coef_limit(1), R_limit(1), alpha_limit(1)], ...
    [Ta_limit(2), coef_limit(2), R_limit(2), alpha_limit(2)],lsqOpts);
% [coef_lsqXY,resnorm,residual]=lsqcurvefit(funFit2,Input_0,xx,yy,...
%     [-100, 30, 1e-7, 2], ...
%     [100, 150, 1, 10],lsqOpts);
    
        lsqFit(deep,1) = Anom(deep,1);%coef_lsqXY(1);
        lsqFit(deep,2) = coef_lsqXY(2);
        lsqFit(deep,3) = coef_lsqXY(3);
        
        Rsquare(deep,1) = resnorm;
        lsqFit(deep,4) = coef_lsqXY(4);

else
    
        lsqFit(deep,1) = nan;
        lsqFit(deep,2) = nan;
        lsqFit(deep,3) = nan;
        lsqFit(deep,4) = nan;   

        Rsquare(deep,1) = nan;
       
end

end
funFit2=@(Input,r)real(Input(1)).*exp(-(1/real(Input(4))).*(abs(r).^real(Input(4)))...
    ./(real(Input(3))^real(Input(4))));

%Save Fitting 
save(filesave2,'lsq*','funFit2','Z','Rsquare',...
          'distance','var','ref_varOut','varA','see', 'Anom')
clearvars lsq* Rsquare var varA see
end

%% 3 Parameters

for f =1:3; 
disp(['----- Field: ',num2str(field{f}), '-----']);
eval(['var = Is',num2str(fields{f}),';']); %var = Isrho;    

eval(['mPvar = autumn.m',num2str(fields{f}), ';']);
% eval(['var = Is',num2str(fields{f})]);
% eval(['mPvar = autumn.m',num2str(fields{f})]);
%mPvar = autumn.mrho; %%% change the reference 

ref_varOut = repmat(mPvar,1,length(distance));
      varA = (var - ref_varOut);
       Z = pres(:,1);   
     
     
       
%FLAGS & names
filesave3 = [path_io, 'sortN_',num2str(field{f}),'_fitparam3.mat'];
            
%FITTING 

%Function & Method 
funFit3=@(Input,r)( real(Input(1)) + coef_0.*r.^2 )...
      .* exp(-(1/real(Input(4))).*(abs(r).^real(Input(4))) ./(real(Input(3))^real(Input(4))));


lsqOpts = optimoptions('lsqcurvefit',...
    'MaxFunEvals', 1e6, 'MaxIter', 1e4,'Display','off'); 

%START
for deep = 1:200
   
disp(['Depth: ',num2str(Z(deep)),'m -----'])

x = distance';
y = varA(deep,:);

   ind = find(isnan(y));
x(ind) =[];
y(ind) =[];

%    ind = find(x==0);
% x(ind) =[];
% y(ind) =[];

if  ~isempty(x)

    xx = [-x(end:-1:1),x];
    yy = [y(end:-1:1),y]; 

    if flagplot     
    plot(x',y','ko'),hold on    
    end
    
% Compute Fitting
% method (b)            
   see(deep)=abs(min(yy))- abs(Input_0(1));
% [coef_lsqXY,resnorm,residual]=lsqcurvefit(funFit,Input_0,xx,yy);
[coef_lsqXY,resnorm,residual]=lsqcurvefit(funFit3,Input_0,xx,yy,...
    [Ta_limit(1), coef_limit(1), R_limit(1), alpha_limit(1)], ...
    [Ta_limit(2), coef_limit(2), R_limit(2),  alpha_limit(2)],lsqOpts);
% [coef_lsqXY,resnorm,residual]=lsqcurvefit(funFit3,Input_0,xx,yy,...
%     [-100, 30, 1e-7, 2], ...
%     [100, 150, 1, 10],lsqOpts);

        lsqFit(deep,1) = coef_lsqXY(1);
        lsqFit(deep,2) = coef_lsqXY(2);
        lsqFit(deep,3) = coef_lsqXY(3);
        
        Rsquare(deep,1) = resnorm;
        lsqFit(deep,4) = coef_lsqXY(4);

else
    
        lsqFit(deep,1) = nan;
        lsqFit(deep,2) = nan;
        lsqFit(deep,3) = nan;
        lsqFit(deep,4) = nan;   

        Rsquare(deep,1) = nan;
        
        
end

end

%Save Fitting 

save(filesave3,'lsq*','funFit3','Z','Rsquare',...
          'distance','var','ref_varOut','varA','see')
clearvars lsq* Rsquare var varA see
end

%% 4 Parameters

for f =1:3; 
disp(['----- Field: ',num2str(field{f}), '-----']);

eval(['var = Is',num2str(fields{f}),';']); %var = Isrho;    

eval(['mPvar = autumn.m',num2str(fields{f}), ';']);
%mPvar = autumn.mrho; %%% change the reference 

ref_varOut = repmat(mPvar,1,length(distance));
      varA = (var - ref_varOut);
       Z = pres(:,1);   

%FLAGS & names
filesave4 = [path_io, 'sortN_',num2str(field{f}),'_fitparam4.mat'];

%FITTING 

%Function & method
% funFit=@(Input,r)( real(Input(1)) + real(Input(2)).*r.^2 )...
%       .* exp(-(1/real(Input(4))).*...
%         (abs(r).^real(Input(4))) /(real(Input(3))^real(Input(4)))) ;
funFit4=@(Input,r)( real(Input(1)) + real(Input(2)).*r.^2 )...
      .* exp(-(1/real(Input(4))).*...
        (abs(r).^real(Input(4))) /(real(Input(3))^real(Input(4)))) ;


lsqOpts = optimoptions('lsqcurvefit',...
    'MaxFunEvals', 1e6, 'MaxIter', 1e4,'Display','off'); 

%%START...
for deep =  1:200
disp(['Depth: ',num2str(Z(deep)),'m -----'])

x = distance';
y = varA(deep,:);

   ind = find(isnan(y));
x(ind) =[];
y(ind) =[];

%    ind = find(x==0);
% x(ind) =[];
% y(ind) =[];

if  ~isempty(x)

    xx = [-x(end:-1:1),x];
    yy = [y(end:-1:1),y]; 

    if flagplot     
    plot(x',y','ko'),hold on    
    end
    
% Compute Fitting
% method (b)            
[coef_lsqXY,resnorm,residual]=lsqcurvefit(funFit4,Input_0,xx,yy,...
    [Ta_limit(1), coef_limit(1), R_limit(1), alpha_limit(1)], ...
    [Ta_limit(2), coef_limit(2), R_limit(2),  alpha_limit(2)],lsqOpts);

        lsqFit(deep,1) = coef_lsqXY(1);
        lsqFit(deep,2) = coef_lsqXY(2);
        lsqFit(deep,3) = coef_lsqXY(3);
        lsqFit(deep,4) = coef_lsqXY(4);
     

else
    
        lsqFit(deep,1) = nan;
        lsqFit(deep,2) = nan;
        lsqFit(deep,3) = nan;
        lsqFit(deep,4) = nan;         
        
       
end

end

%Save Fitting 
save(filesave4,'lsq*','funFit4','Z','distance','var','ref_varOut','varA') 
clearvars lsq* Rsquare var varA see
end



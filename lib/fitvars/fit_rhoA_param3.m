
% clearvars -except eddy eddy_center no_param;
% clc;close all
% run(['../paths.m']);
%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';
%
path_io = ['',computer,'eddy3D/io/']
warning off

%LOAD FIELDS
field = {'tempA','salA','rhoA'};      f = 3; 
disp(['----- Field: ',num2str(field{f}), '-----'])

%load('../../io/sortN.mat','Nsrho','Nsort_rad','pres')
load('../../io/sortI.mat','Isrho','Isort_rad','pres')
  distance = Isort_rad;%Nsort_rad;
       var = Isrho;    
load('../../io/sortO.mat','Osrho','mPrhoout')
load('../../io/ref_pro.mat','autumn')
mPvar = autumn.mrho; %%% change the reference 
ref_varOut = repmat(mPvar,1,length(distance));
      varA = (var - ref_varOut);
       Z = pres(:,1);   
     
     
       
%FLAGS & names
flagplot = 0;
flagfig  = 0;
flagsave = 1;
filesave = [path_io, 'sortN_',num2str(field{f}),'_fitparam3.mat'];
            
       
%FITTING 
%First guess fitting parameters
     Ta0 = -0.5;
     R0 = 10;
 coef_0 = 1e-3;
alpha_0 = 2;
Input_0 = [Ta0,coef_0,R0];

%Function & Method
funFit=@(Input,r)( real(Input(1)) + real(Input(2)).*r.^2 )...
      .* exp(-(1/2).*(abs(r).^2) ./(real(Input(3))^2));

lsqOpts = optimoptions('lsqcurvefit',...
    'MaxFunEvals', 1e6, 'MaxIter', 1e4,'Display','off'); 

  
%START
for deep = 1:400
   
disp(['Depth: ',num2str(Z(deep)),'m -----'])


x = distance';
y = varA(deep,:);

   ind = find(isnan(y));
x(ind) =[];
y(ind) =[];

   ind = find(x==0);
x(ind) =[];
y(ind) =[];

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
[coef_lsqXY,resnorm,residual]=lsqcurvefit(funFit,Input_0,xx,yy,[],[],lsqOpts);
    
 
    if flagplot   
        figure
        hold on
        %plot(x,y,'bo',x,funFit(coef_lsq,x),'k-');
        title(['Depth: ',num2str(Z(deep)),''])
        scatter(x,y,'filled','marker','d'),hold on
        plot(x,funFit(coef_lsqXY,x),'k-','linewidth',1);
        if flagfig;saveas(gcf,'test.png'); end
        
    end


        lsqFit(deep,1) = coef_lsqXY(1);
        lsqFit(deep,2) = coef_lsqXY(2);
        lsqFit(deep,3) = coef_lsqXY(3);
        
        Rsquare(deep,1) = resnorm;
%         lsqFit(deep,4) = coef_lsqXY(4);

               

else
    
        lsqFit(deep,1) = nan;
        lsqFit(deep,2) = nan;
        lsqFit(deep,3) = nan;
%         lsqFit(deep,4) = nan;   

        Rsquare(deep,1) = nan;
        
        
end

end

%Save Fitting 
if flagsave
save(filesave,'lsq*','funFit','Z','Rsquare',...
          'distance','var','ref_varOut','varA','see')
end


%clear all;
clc;close all

%Load Fields
field = {'tempA','salA','rhoA'};  
for fi = 3
disp(['----- Field: ',num2str(field{fi}), '-----'])
 

filesave = [path_output, 'sortN_',num2str(field{fi}),'_fitparam3.mat'];
load(filesave)
funFit3 = funFit;
lsqFit3 = lsqFit;

filesave = [path_output, 'sortN_',num2str(field{fi}),'_fitparam4.mat'];
load(filesave)
funFit4 = funFit;
lsqFit4 = lsqFit;

%Flags figs
flagfig1 = 1;


% Start the evaluation
sdeep = 1:400;
pres  = Z(sdeep);
r     = -100:1:100;
   
Lewq =[];
Cewq =[];
for deep = sdeep
    
x = distance';
y = varA(deep,:);


       Input3 = real(lsqFit3(deep,:));
Lewq3(deep,:) = funFit3(Input3,x);


       Input4 = real(lsqFit4(deep,:));
Lewq4(deep,:) = funFit4(Input4,x);
  
 if flagfig1
 hfig = figure('visible','off');
 hold all
 scatter(x,y)

 plot(x,Lewq3(deep,:),'b','linewidth',1);
 plot(x,Lewq4(deep,:),'r','linewidth',1);
 title(['Depth: ',num2str(Z(deep)),'m'])
 legend('','p3','p4')
 saveas(hfig,['./levels/',num2str(field{fi}),'_fitting_param',num2str(Z(deep)),'.png'])
 close(hfig)
 end
end


end



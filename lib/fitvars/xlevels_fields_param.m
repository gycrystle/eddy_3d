%clear all;
clc;
%Load directories & paths
%................................
computer ='/home/cgreace/tuto1/';
%
path_io = ['',computer,'eddy3D/io/'];
path_output = ['',computer,'/eddy3D/output/',num2str(eddy),'/',num2str(eddy_center),'/'];
%close all

%Load Fields
field = {'tempA','salA','rhoA'};  
xxx=0:150;
for fi = 3
disp(['----- Field: ',num2str(field{fi}), '-----'])
 
filesave = [path_io, 'sortN_',num2str(field{fi}),'_fitparam2.mat'];
load(filesave)
%funFit2 = funFit;
p_lsqFit2 = lsqFit;

filesave = [path_io, 'sortN_',num2str(field{fi}),'_fitparam3.mat'];
load(filesave)
%funFit3 = funFit;
p_lsqFit3 = lsqFit;

filesave = [path_io, 'sortN_',num2str(field{fi}),'_fitparam4.mat'];
load(filesave)
%funFit4 = funFit;
p_lsqFit4 = lsqFit;

%Flags figs
flagfig1 = 1;


% Start the evaluation
sdeep = 1:2:200
pres  = Z(sdeep);
r     = -160:1:160;
   
Lewq =[];
Cewq =[];
for deep = sdeep
    
x = distance';
y = varA(deep,:);

       Input2 = real(p_lsqFit2(deep,:));
Lewq2(deep,:) = funFit2(Input2,xxx);

       Input3 = real(p_lsqFit3(deep,:));
Lewq3(deep,:) = funFit3(Input3,xxx);

       Input4 = real(p_lsqFit4(deep,:));
Lewq4(deep,:) = funFit4(Input4,xxx);
  
 if flagfig1
 hfig = figure%('visible','off')
 hold all
 scatter(x,y)

 plot(xxx,Lewq2(deep,:),'k','linewidth',1);
 plot(xxx,Lewq3(deep,:),'b','linewidth',1);
 plot(xxx,Lewq4(deep,:),'r','linewidth',1);
 ylim([-1 0.05])
 title(['Depth: ',num2str(Z(deep)),'m'])
 legend('','generic','p3','p4', 'Location', 'southeast')
 saveas(hfig,[path_output, 'levels/',num2str(field{fi}),'_fitting_param',num2str(Z(deep)),'.png'])
 close(hfig)
 end
end


end



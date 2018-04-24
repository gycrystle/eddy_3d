% clear all;clc;close all
% addpath('~/Documents/MATLAB/AMEDA')
% addpath('~/Documents/MATLAB/matpalettes')
% addpath('~/Documents/MATLAB/m_map')
% addpath('~/Documents/MATLAB//bathy')
% path_argo = ['',computer,'/IMED/ANALYSIS/MARGO/'];
% addpath([path_argo 'argofun/'])
load('bathy/med_coast.mat')


minlat = 32.8;                                                      
maxlat = 35.4;                                                       
minlon = 24;                                                        
maxlon = 27.5;
m_proj('Mercator','lat',[minlat maxlat],'lon',[minlon maxlon]);


i= 4
path_out = [pwd '/loopsfigs',num2str(i),'/']
load(['drifter',num2str(i),'.mat'])

% treatment for a specific trajectory
driftnames=fieldnames(drifter);

traject = drifter;

trajectlon = traject(i).lon;
trajectlat = traject(i).lat;
trajectdate = traject(i).date;
ts = traject(i).date;

[indnan]=find(isnan(trajectlon))
trajectlon(indnan)=[];
trajectlat(indnan)=[];
trajectdate(indnan)=[];



deltadate= 12;
datemin=floor(min(trajectdate));
datemax=floor(max(trajectdate)-deltadate);

datestr(datemin)
datestr(datemax)

% plot each 20days segments
close all
j=0;
k=0;
for d=datemin:datemax
    k = k+1
     ind=find(trajectdate>d-.5 & trajectdate<d-.5+deltadate);
    if ~isempty(ind) && length(ind)>6
        
        % segments coordinates
        lond1=trajectlon(ind);
        latd1=trajectlat(ind);
        lond2=trajectlon(ind+1);
        latd2=trajectlat(ind+1);
        dated=trajectdate(ind);
        
        

        % disjoind extremity
        lond2(1:end-1)=lond2(1:end-1)-diff(lond1)/1000;
        latd2(1:end-1)=latd2(1:end-1)-diff(latd1)/1000;
        
        % compute intersection between segments
        % [(lond1,latd1) (lond2,latd2)]
        XY1=[lond1 latd1 lond2 latd2];
        XY2=XY1;
        out = lineSegmentIntersect(XY1,XY2);
        
        % find intersection indices
        % ind2 are indices in XY1 with intersection
        [ind1,ind2]=find(~isnan(out.intMatrixX) & out.intMatrixX~=0 &...
                        ~isnan(out.intMatrixY) & out.intMatrixY~=0 );
        
        if ~isempty(ind1)
            % test if the potential loop gots an other intersection
            % with an indice include in the loop
            if isempty(ind1(ind2>ind2(1) & ind2<ind1(1) & ind1<ind1(1)))
                % if no then record as a shape
                date = dated(ind1(1))-dated(ind2(1)+1);
                if date>1 %&& (j==0 ||date~=loop(1).date(j))
                    j=j+1;
                    
                    %record
                    loop(1).segLxy{j}   = XY1;              
                    loop(1).segLdate{j} = dated;
                                      
                 %find intersection point
                  [row col] = find(out.intAdjacencyMatrix==1);
                       xpos = out.intMatrixX(row,col);
                       ypos = out.intMatrixY(row,col);
                    
                    %record   
                    loop(1).xint{j} = unique(xpos(~isnan(xpos)));
                    loop(1).yint{j} = unique(ypos(~isnan(ypos)));
                      
                    % extract shape loop > 1 day
                    loop(1).shape{j} = XY1(2:end,1:2);
                    loop(1).tc{j}    = dated;
               
                    % find loop radius (help of mean_radius)
                      grid_ll = 1;
                      xdata = loop(1).shape{j}(:,1)';
                      ydata = loop(1).shape{j}(:,2)';
                 [R,A,P,ll] = mean_radius([xdata;ydata],grid_ll);
                 
                 % find loop radius (help of compute_ellip)
                 [xbary,ybary,z,a,b,alpha,lim]=compute_ellip([xdata;ydata],0)
                 
               
    figure
    m_plot(xdata,ydata),hold on  
    m_grid('tickdir','in','xtick',4,'ytick',4,'linewidth',1,'Fontsize',14); 
    [el X1] = plotellipseT(z,a,b,alpha, '-')
    dste = ['',datestr(d-.5,'dd/mmm'),'--',datestr(d+.5+deltadate,'dd/mmm'),'']
    t = title(dste)
    fileF = [path_out 'loop',num2str(i),'__No',num2str(k),'.png']
    saveas(gcf,fileF)
 
  [xbary,ybary,z,a,b,alpha,lim]=compute_ellip([xdata;ydata],1)
 [eR,eA,eP,ell] = mean_radius([X1(1,:);X1(2,:)],grid_ll);
 [turn,angle] = turn_angle([xdata;ydata],grid_ll);
 

                    %record
                    loop(1).xc{j}    = xbary;
                    loop(1).yc{j}    = ybary;              
                 
                              if a>=b && a~=0
                                ellip = 1-b/a;
                            elseif a<b && b~=0
                                ellip = 1-a/b;
                            else
                                ellip = NaN;
                              end
                    
                              
                 %record variables for every loop (continued..)
                    loop(1).rmax{j}   = R(1);
                    loop(1).area{j}   = A;   
                    loop(1).phery{j}  = P; 
                    loop(1).xbary1{j} = ll(1);
                    loop(1).ybary1{j} = ll(2);
                    loop(1).ellip{j}  = ellip;
                    loop(1).ermax{j}   = eR(1);
                    loop(1).earea{j}   = eA;   
                    loop(1).ephery{j}  = eP; 
                    loop(1).exbary1{j} = ell(1);
                    loop(1).eybary1{j} = ell(2);
                    loop(1).ea{j}  = a;     
                    loop(1).eb{j}  = b; 
                    loop(1).ealpha{j}  = alpha;   

                  % find loop velocity Vmax
                    d1  = datetime(loop.tc{j}(end), 'ConvertFrom', 'datenum');
                    d2  = datetime(loop.tc{j}(1), 'ConvertFrom', 'datenum');
                    dif = (d1 - d2);
                    
                    T   = hours(dif)/ 24;  %[days]
                    period = T/turn;
                    
                 velmax = (loop(1).ephery{j}*1000) ./ (period*24*60*60); %[m/s]
                 

                    
                  %record variables for every loop 
                    loop(1).Tloop{j} = T;
                    loop(1).period{j} = period;
                    loop(1).velmax{j} = velmax;
                    
                    
                    
                end
            end 
% 
% %             remove the from trajectories
%             for n=2:length(driftnames)
%                traject(i).(driftnames{n})(ind(ind2(1):ind1(1)))=[];
%             end
%             
 
 
        
        end
    end
    
end




%----------------------------------------
% save loops in structure array
path_out = [pwd '/']
filename = sprintf('traj_loops_%d.mat',i)
save([path_out filename],'loop')




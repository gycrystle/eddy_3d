%
    % map plot
    h_coast=1; bath=0;
    if h_coast; coast=csvread('bathy/new_bathy.csv');end
    if bath;    load('bathy/bathy_med');end
    %
    m_proj('Mercator','lat',[minlat maxlat],'lon',[minlon maxlon]);
    %
    hmap = figure;
    for a = 1:argonumber;%length(name)
        
        notnan = find(~isnan(x(:,a)));
        xx = x(notnan,a);
        yy = y(notnan,a);
        %namea=name{notnan};
        if all(isnan(x(:,a)))
           name(:,a)=[]; %C(2,:) = []
           info(:,a)=[];
        end
        m = m_plot(xx,yy,mark{a},'Color',col{a},...
            'MarkerFaceColor',facol{a},...
            'MarkerSize',6,'linewidth',0.3,'linestyle','--');
        
        eval(['m',num2str(a),'= m;'])
        
        hold on
    end
    legendInfo = name;%['',name,' ',info,''];
    legend(legendInfo,'location','southwest')
    t = title(periodT,'fontsize',10);
    set(t, 'horizontalAlignment', 'left')
    set(t, 'units', 'normalized')
    h1 = get(t, 'position');
    set(t, 'position', [h1(3) h1(2) 1])
    if h_coast
        [X,~]=m_ll2xy(coast(:,1),coast(:,2),'clip','patch');
        k=find(isnan(X(:,1)));
        for i=1:length(k)-1,
            xc=coast([k(i)+1:(k(i+1)-1) k(i)+1],1);
            yc=coast([k(i)+1:(k(i+1)-1) k(i)+1],2);
            m_patch(xc,yc,[.9 .9 .9]);
        end
    else
        m_coast('color','k');
    end
    m_grid('tickdir','in','xtick',4,'ytick',4,'linewidth',1,'Fontsize',14);
    %
    load([path_io, '/ref_pro.mat'])
    m_plot(autumn.lon, autumn.lat, 'y*','linewidth',0.5,'markersize',6);
    %
    m_plot(mLon,mLat,'k+','linewidth',3,'markersize',10)
    m_range_ring(mLon,mLat,mRad,'color','b'); %[1, 0.6, 0.7843]pink outside eddy
    %m_range_ring(mLon,mLat,mRad2,'color','[0.6,0.8,1]'); %lightblue inside eddy
    %
    % Inmost and outmost profile
    [iout,jout]=find(radius==max(max(radius(find(radius<mRad2)))));
    [iin,jin]=find(radius==min(min(radius)));
    m_plot(x(iout,jout),y(iout,jout),'b*');
    m_plot(x(iin,jin),y(iin,jin),'r*');
%
    

    %if flagfig
        figname ='mapnew';
        print(hmap,[path_output, figname],'-dpng','-r300')%'../output/'
    %end
    
    %% map plot
    %
    % load('./3Dargo/sortI.mat','in*')
    % m_plot(inLon,inLat,'k+')
    % load('./3Daviso/sortI.mat','in*')
    % m_plot(inLon,inLat,'b+')
    %
    %
    % load('./3Dargo/sortO.mat','out*')
    % m_plot(outLon,outLat,'k+')
    % load('./3Daviso/sortO.mat','out*')
    % m_plot(outLon,outLat,'b+')
    %

    %
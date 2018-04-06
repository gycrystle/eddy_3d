%
clearvars lon lat pres temp rho time sal
load([path_io, '/data_perargo10.mat']);
    % map plot
    h_coast=1; bath=0;
    if h_coast; coast=csvread('bathy/new_bathy.csv');end
    if bath;    load('bathy/bathy_med');end
    %
    m_proj('Mercator','lat',[minlat maxlat],'lon',[minlon maxlon]);
    %
    hmap = figure;
    for a = 1:argonumber;%length(name)
        
        notnan = find(~isnan(lon(:,a)));
        xx = lon(notnan,a);
        yy = lat(notnan,a);
        m = m_plot(xx,yy,mark{a},'Color',col{a},...
            'MarkerFaceColor',facol{a},...
            'MarkerSize',5,'linewidth',0.3,'linestyle','--');
        
        eval(['m',num2str(a),'= m;'])
        legendInfo{a} = ['',name{a},' '];
        hold on
    end
    legend(legendInfo,'location','northeastoutside')
%     t = title(periodT,'fontsize',10);
%     set(t, 'horizontalAlignment', 'left')
%     set(t, 'units', 'normalized')
%     h1 = get(t, 'position');
%     set(t, 'position', [h1(3) h1(2) 1])
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
    m_grid('tickdir','in','xtick',4,'ytick',4,'linewidth',1,'Fontsize',11);
    %
    
    figname ='All_Argo_Location';
    print(hmap,[path_output, figname],'-dpng','-r300')
    %
function [Tangle,angleD] = turn_angle(xy,grid_ll)

% Default grid is (lon,lat)
%----------------------------------------
if nargin==1
    grid_ll = 1;
end

figopen  = 0;
xdata = xy(1,:);
ydata = xy(2,:);

% Size of the polygon
%----------------------------------------
lim = size(xy,2)-1;

% Barycenter computation
%----------------------------------------
somme_x = sum(xy(1,1:lim));
somme_y = sum(xy(2,1:lim));

ll(1) = somme_x/lim;
ll(2) = somme_y/lim;

% Initialisation
%----------------------------------------
distance=zeros(1,lim+1);
aire=zeros(1,lim);
param=zeros(1,lim);



% Distance = distance between barycentre and every point of the polygon
%----------------------------------------
xs(1)=ll(1);
ys(1)=ll(2);

for point=1:lim+1
    xs(2)=xy(1,point);
    ys(2)=xy(2,point);

    if grid_ll
        [distance(point) phaseangle(point)] = sw_dist(ys,xs,'km');
    else
        distance(point) = sqrt(diff(xs).^2+diff(ys).^2); % km
    end
end

% Distance2 = distance between 2 consecutives points of the polygon
%----------------------------------------
if grid_ll
    [distance2 phaseangle2]= sw_dist(xy(2,:),xy(1,:),'km');
else
    distance2 = sqrt(diff(xy(1,:)).^2+diff(xy(2,:)).^2); % km
end


% Perimeter of the polygon computation
%----------------------------------------
P = sum(distance2(:));

% Angle between polygon segments
%----------------------------------------
P = sum(distance2(:));
pointP0 = [xs(1),ys(1)];
for point= 1:lim
    
pointP1 = [xdata(point),ydata(point)];
pointP2 = [xdata(point+1),ydata(point+1)];

        p1 = [pointP0;pointP1]
        p2 = [pointP0;pointP2]

         v1  = [pointP2-pointP0]
         v2  = [pointP1-pointP0]    
if figopen
    figure(1)
    plot(p1(:,1),p1(:,2),'-*r')
    hold on
    plot(p2(:,1),p2(:,2),'-*r')
    hold on

    figure(2)

    quiver(v1,v2)
    hold on
end

angleV(point) = mod( atan2( det([v1;v2]) , dot(v1,v2) ) , 2*pi );
angleD(point) =  atan2d( det([v1;v2]) , dot(v1,v2) );


clamp = @(val, low, high) min(max(val,low), high);
angle = acosd( clamp(dot(v1,v2) / norm(v1) / norm(v2), -1, 1));

angelDot(point) = angle;
vc = cross([v1,0], [v2,0]);
anticlock = vc(3) > 0;

end

 
Tangle = sum(abs(angleD(:)))./360;



end


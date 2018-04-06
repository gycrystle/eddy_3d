A=-0.5; %Ta_0
B1=1e-3; %coef_0
B2=0.11;
B3=0.1;
r=linspace(1,100);
alpha1=2;
alpha2=1.5;
alpha3=2;
Rmax1=10;
Rmax2=20;
Rmax3=40;

y1=(A+B1*r.^2).*exp(-((r/Rmax1).^alpha1)/alpha1);
y2=(A+B1*r.^2).*exp(-((r/Rmax2).^alpha1)/alpha1);
y3=(A+B1*r.^2).*exp(-((r/Rmax3).^alpha1)/alpha1);


figure;
hold on
plot(r,y1,r,y2,r,y3);
legend show
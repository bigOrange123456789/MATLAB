function [] = fit()
x = linspace(0,4*pi,10);
y = sin(x);
p = polyfit(x,y,7);
x1 = linspace(0,4*pi);
y1 = polyval(p,x1);
plot(x1,y1);

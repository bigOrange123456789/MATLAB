%绘制球谐函数
%球谐函数的方程包括 Legendre 函数的一个项以及一个复指数
dx = pi/60;
alt = -pi/2:dx:pi/2;
az = 0:dx:2*pi;
[phi,theta] = meshgrid(az,alt);%基于向量 x 和 y 中包含的坐标返回二维网格坐标。

l = 3;
Plm = legendre(l,cos(theta));

m = 2;
P32 = reshape(Plm(m+1,:,:), size(phi));

a = (2*l+1)*factorial(l-m);
b = 4*pi*factorial(l+m);
C = sqrt(a/b);
Y32 = C .* P32 .* exp(1i*m*phi);

[Xm,Ym,Zm] = sph2cart(phi, theta, real(Y32));%将球面坐标转换为笛卡尔坐标全页折叠%real复数的实部
surf(Xm,Ym,Zm)
title('$Y_3^2$ spherical harmonic','interpreter','latex')
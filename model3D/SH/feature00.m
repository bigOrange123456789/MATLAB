function cc = feature00(data)
%data: n*3  % x,y,z
%FEATURE 此处显示有关此函数的摘要
%   此处显示详细说明
x=data(:,1);
y=data(:,2);
z=data(:,3);

[a,e,r]=cart2sph(x,y,z);

l=2;%degree
num=(l+2)*(l+1)/2;%l+1的前n项和         %对于ｌ阶的展开，一共有多少项
x0=zeros(1,2*num);%乘以2应该是考虑虚部  %系数初值为０;

ff=optimset;%optimset 设置优化的结构体
ff.MaxFunEvals=50000;%'MaxFunEvals' - 函数计算的最大次数
ff.MaxIter=5000;%'MaxIter' - 最大迭代次数
lb=[];ub=[];  
[cc,~,~] = lsqcurvefit(@myfunhopeho,x0,[sin(a');e'],r',lb,ub,ff);
end


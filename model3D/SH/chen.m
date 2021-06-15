l=2;%degree
num=(l+2)*(l+1)/2;%对于ｌ阶的展开，一共有多少项
x0=zeros(1,2*num);%系数初值为０;

ff=optimset;%optimset 设置优化的结构体
ff.MaxFunEvals=50000;%'MaxFunEvals' - 函数计算的最大次数
ff.MaxIter=5000;%'MaxIter' - 最大迭代次数
lb=[];ub=[];  
[cc,resnorm,residual] = lsqcurvefit(@myfunhopeho,x0,X,ydata,lb,ub,ff);
%非线性最小二乘求解器
%lsqcurvefit 用最小二乘拟合曲线
%x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options)
%输入：
%从 x0 开始，求取合适的系数 x，使非线性函数 fun(x,xdata) 对数据 ydata 的拟合最佳
%lb：参数下界
%ub：参数上界    使解始终在 lb ≤ x ≤ ub 范围内
%输出：
%[x,resnorm,residual]
%系数 x
% x 处的残差的 2-范数平方值：sum((fun(x,xdata)-ydata).^2)。
%描述退出条件的值 exitflag
cc%-cc_
size(cc)
     
     
     
     
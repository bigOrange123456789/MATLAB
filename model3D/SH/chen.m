l=2;%degree
num=(l+2)*(l+1)/2;%���ڣ�׵�չ����һ���ж�����
x0=zeros(1,2*num);%ϵ����ֵΪ��;

ff=optimset;%optimset �����Ż��Ľṹ��
ff.MaxFunEvals=50000;%'MaxFunEvals' - ���������������
ff.MaxIter=5000;%'MaxIter' - ����������
lb=[];ub=[];  
[cc,resnorm,residual] = lsqcurvefit(@myfunhopeho,x0,X,ydata,lb,ub,ff);
%��������С���������
%lsqcurvefit ����С�����������
%x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options)
%���룺
%�� x0 ��ʼ����ȡ���ʵ�ϵ�� x��ʹ�����Ժ��� fun(x,xdata) ������ ydata ��������
%lb�������½�
%ub�������Ͻ�    ʹ��ʼ���� lb �� x �� ub ��Χ��
%�����
%[x,resnorm,residual]
%ϵ�� x
% x ���Ĳв�� 2-����ƽ��ֵ��sum((fun(x,xdata)-ydata).^2)��
%�����˳�������ֵ exitflag
cc%-cc_
size(cc)
     
     
     
     
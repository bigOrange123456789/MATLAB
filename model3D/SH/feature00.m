function cc = feature00(data)
%data: n*3  % x,y,z
%FEATURE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
x=data(:,1);
y=data(:,2);
z=data(:,3);

[a,e,r]=cart2sph(x,y,z);

l=2;%degree
num=(l+2)*(l+1)/2;%l+1��ǰn���         %���ڣ�׵�չ����һ���ж�����
x0=zeros(1,2*num);%����2Ӧ���ǿ����鲿  %ϵ����ֵΪ��;

ff=optimset;%optimset �����Ż��Ľṹ��
ff.MaxFunEvals=50000;%'MaxFunEvals' - ���������������
ff.MaxIter=5000;%'MaxIter' - ����������
lb=[];ub=[];  
[cc,~,~] = lsqcurvefit(@myfunhopeho,x0,[sin(a');e'],r',lb,ub,ff);
end


function y=myfunhopeho(cc,X)
%cc是系数:1*2n
%X: 2*10000
%Y: 1*10000
l=2;%degree

num=(l+2)*(l+1)/2;%对于ｌ阶的展开，一共有多少项

pp=zeros(sum(1:l+1),length(X));

for j=0:l
    begin=sum(1:j)+1;
    pp(begin:begin+j,:)=legendre(j,X(1,:));%p: j*rx    连带legend函数
    %disp(size(p));
    %P = legendre(n,X) 
    %为 X 中的每个元素计算 连带 Legendre 函数。
    %阶数为 n、级数为0, 1, ..., n 
end

indexn=zeros(1,num);
indexm=zeros(1,num);
k=1;
for i=0:l
    for j=0:i
        indexn(k)=i;
        indexm(k)=j;
        k=k+1;
    end
end

y=0;
x2=X(2,:);
for  k=1:num %各个基的加权和
    i1=cc(2*k-1);
    i2=cc(2*k);
    v1=cos(indexm(k)*x2);
    v2=sin(indexm(k)*x2);
    y=y+(i1*v1+i2*v2).*pp(k,:);
end

end
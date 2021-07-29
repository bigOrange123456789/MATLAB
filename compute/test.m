%[names,mat]=read("5.txt");
%dis=zeros(length(vs));
%sum((vs([1 2;1 2])-vs([1 2;1 2])).^2)

p=[1 1;2 2;3 3]; % n*10
n=length(p);
c=length(p(1,:));
p1=reshape(p,n,1,c);
p2=reshape(p,1,n,c);
fun = @(a,b) (a - b).^2;
b=bsxfun(fun,p1,p2);
%  10*10*n   10*1*n  1*10*n
%            n*1*v  1*n*v
s=sum(b,3);
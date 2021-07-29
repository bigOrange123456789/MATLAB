function dis = distance(vectors)%input:  n*c output: n*n 
vectors=gpuArray(vectors);%使用GPU后上限在1200左右%不使用GPU后上限高于1800
sizeV=size(vectors);
n=sizeV(1);
c=sizeV(2);
p1=reshape(vectors,n,1,c);
p2=reshape(vectors,1,n,c);
fun = @(a,b) (a - b).^2;
b=bsxfun(fun,p1,p2);
%  10*10*n   10*1*n  1*10*n
%            n*1*v  1*n*v
dis=sqrt(sum(b,3));
end


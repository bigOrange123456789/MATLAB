m=Mesh("man");
m.draw();
c=[0.4,-0.44,0]
mat1=[ [1 0 0 -c(1)];
       [0 1 0 -c(2)];
       [0 0 1 -c(2)];
       [0 0 0 1    ]]
mat2=rotz(60)
mat2=[mat2;[0 0 0]];
mat2=[mat2';[0 0 0 1]]';
mat3=[ [1 0 0 c(1)];
       [0 1 0 c(2)];
       [0 0 1 c(3)];
       [0 0 0 1  ]]
m.applyMatrix1(mat2*mat1)
%m.applyMatrix1(mat3*mat2*mat1)

%{
m.applyMatrix1([ [1 0 0 0.2];
                 [0 1 0 0.5];
                 [0 0 1 0];
                 [0 0 0 1]])


m.applyRotation(0,0,-30)
m.applyRotation(-15,0,0)
%}
x=0;y=0;z=0;
a = 1;b = 1;c = 1;
% 8个顶点分别为：
% 与(0,0,0)相邻的4个顶点
% 与(a,b,c)相邻的4个顶点
V = [
    0 0 0;
    a 0 0;
    0 b 0;
    0 0 c;
    a b c;
    0 b c;
    a 0 c;
    a b 0];
V(:,1)=V(:,1)-a/2+x;
V(:,2)=V(:,2)-b/2+y;
V(:,3)=V(:,3)-c/2+z;
% 6个面
% 以(0,0,0)为顶点的三个面
% 以(a,b,c)为顶点的三个面
F = [1 2 7 4;1 3 6 4;1 2 8 3;
    5 8 3 6;5 7 2 8;5 6 4 7];
hold on
patch('Faces',F,'Vertices',V,'FaceColor','none','LineWidth',1.5);





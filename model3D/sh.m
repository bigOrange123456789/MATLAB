function  sh()

% ������г����ͼ��

% degree, Ynm��n, ��

% order,  Ynm��m, ��

% method, ��ͼ��R

%% ʾ�� - ������г������

maxD = 3; % ��߽���

for n = 0:maxD

    
for m = 0:n

subplot(maxD+1,maxD+1,n*(maxD+1)+m+1)

plot_sph_harm(n,m,2);

end

end

function plot_sph_harm(degree,order,method)

%% ����

theta = 0:pi/30:pi;                   % polar angle

phi = 0:pi/30:2*pi;                   % azimuth angle

[phi,theta] = meshgrid(phi,theta);    % define the grid

%% ������г����

Ln = legendre(degree,cos(theta(:,1)),'norm');     % һ�ж�Ӧһ��order

yy = repmat(Ln(order+1,:)',[1,size(theta,2)]); % Ln(i+1,:)��Ӧorder=i

Ynm = yy.*cos(order*phi);                % ��г����, �൱�ڻ�ͼ��color

%% R��ѡ��

if nargin 

switch method

case 1

R = ones(size(phi));      % �����ڵ�λ����

case 2

R = abs(Ynm) + 0.2;       % ��colorһ��

case 3

R = Ynm*0.4 + 1;          % ����ȥ��λ�������α�

case 4

% ����Help�ĵ�'Animating a Surface'

R = 5 + 0.5*Ynm/max(max(abs(Ynm)));

% radius = 5; amplitude = 0.5;

otherwise

error('[ERROR] -- û�и÷��������� method\n')

end

%% ת��Ϊֱ������

Rxy = R.*sin(theta);    % convert to Cartesian coordinates

x = Rxy.*cos(phi);

y = Rxy.*sin(phi);

z = R.*cos(theta);

%% ��ͼ����1 (ע:�����������һЩ���ÿ�)

surf(x,y,z,Ynm,'edgecolor','none','facecolor','interp');

axis equal off     % set axis equal and remove axis

colormap parula;

material shiny;

camzoom(1.5)        % zoom into scene

%% ��ͼ����2 (ע:�������ϡ��һЩ���ÿ�)

surf(x,y,z,Ynm);

light               % add a light

lighting gouraud    % preferred lighting for a curved surface

axis equal off      % set axis equal and remove axis

view(40,30)         % set viewpoint

camzoom(1.5)        % zoom into scene

end

end
end


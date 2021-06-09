%https://lafengxiaoyu.blog.csdn.net/article/details/72812681?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-3.baidujs&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-3.baidujs
function [ simV,simF ] = simplification2( V,F,percent )
[N] = compute_face_normal(V,F);%计算所有平面的法线
N=N';
nv = size(V,1); % 顶点个数
np = percent*nv; % 需要保留的顶点数

%1.计算出所有的平面方程
p=getPlane(V,F,N);
    function p=getPlane(V,F,N)%所有的平面，n*4
        %p = [N, -sum(N .* V(F(:,1),:), 2)];
        v0=V(F(:,1),:);
        d=sum(v0.*N,2);
        p=[N,-d];%每一行对应一个平面
    end

%2.计算全部三角面的矩阵
Q0 = getQ0(p);%面数个4*4的矩阵，size为4*4*n
    function Q0=getQ0(p)
        %bsxfun(@times, permute(p, [2,3,1]), permute(p, [3,2,1]))
        %p的维度是 n*4=n*4*1
        p1=permute(p, [2,3,1]);%4*1*n
        p2=permute(p, [3,2,1]);%1*4*n
        Q0=bsxfun(@times,p1,p2);%4*4*n
    end

%3.计算全部顶点的Q矩阵
Q=getQ(F,Q0,nv);%4*4*nv
    function Q=getQ(F,Q0,nv)
        Q = zeros(4,4,nv);%每个顶点都对应一个4*4的矩阵
        nf = size(F,1);%三角面个数
        for i = 1:nf%遍历三角面
            for j = 1:3%遍历三角面的顶点
                v_indx=F(i,j);%获取三角面上的顶点序号
                Q(:,:,v_indx) = Q(:,:,v_indx) + Q0(:,:,i);%顶点的矩阵等于所有所处三角面的矩阵和
            end
        end
    end

%4.计算每个边的代价
E=getE(F,V);%获取所有边
ne = size(E,1);
    function E=getE(F,V)
        TR = triangulation(F,V);%进行三角剖分，梳理出所有三角形
        E = edges(TR);%返回所有边的顶点索引  ne*2
    end
Qbar = getQbar(Q,E);%使用边矩阵感觉不是很合理，计算出所有的边矩阵 
%Qbar:4*4*ne
    function Qbar=getQbar(Q,E)% compute Q1+Q2 for each pair
        %Qbar = Q(:,:,E(:,1)) + Q(:,:,E(:,2))
        e1=E(:,1);% ne*2 -> ne*1
        e2=E(:,2);
        Qbar = Q(:,:,e1) + Q(:,:,e2);% Q:4*4*nv -> Qbar:4*4*ne
    end
[cost,v]=getcost(V,E,ne,Qbar);
%cost:ne*3 v:4*3*ne
    function [cost,v]=getcost(V,E,ne,Qbar)% a simple scheme: select either v1, v2 or (v1+v2)/2
        %v:4*3*ne (坐标+1)*（3个点）*（边数）
        v=getv(V,E,ne);%4*3*ne
        function v=getv(V,E,ne)
            v1 = getv_4(V,E,ne,1);%4*1*ne
            v2 = getv_4(V,E,ne,2);
            function v_4=getv_4(V,E,ne,col)
                %v1 = permute([V(E(:,1),:),ones(ne,1)], [2,3,1]);%获取边的另一个端点位置
                %v2 = permute([V(E(:,2),:),ones(ne,1)], [2,3,1]);%获取边的另一个端点位置
                vertex_index=E(:,col);%边的第一列数据 ne*1
                vertex_pos=V(vertex_index,:);% V:nv*3 -> vertex_pos:ne*3
                v_4 = permute([vertex_pos,ones(ne,1)], [2,3,1]);%ne*4*1 ->4*1*ne %获取边的一个端点位置 
            end
            vm = 0.5 .* (v1 + v2);%获取边的中点位置
            v = [v1, v2, vm]; % 4*1*ne -> 4*3*ne
        end
        
        cost = zeros(ne,3);%用于记录每条边的代价
        cost(:,1)=get_costi(v(:,1,:),Qbar);% ne*1
        cost(:,2)=get_costi(v(:,2,:),Qbar);
        cost(:,3)=get_costi(v(:,3,:),Qbar);
        
        %mean(V,1)
        
         %{
            for i=1:ne
            if i==1
                %display(cost(i,1))
            end
            if V(E(i,1),1)>0 %如果x>0 代价加100
                cost(i,1)=cost(i,1)+100;
                cost(i,2)=cost(i,2)+100;
                cost(i,3)=cost(i,3)+100;
            end
        end
         %}
        
    end
    function costi=get_costi(vi,Qbar)
            %cost(:,1) = sum(squeeze(sum(bsxfun(@times,v1,Qbar),1)).*squeeze(v1),1)';%坍塌到v1的代价
            %cost(:,2) = sum(squeeze(sum(bsxfun(@times,v2,Qbar),1)).*squeeze(v2),1)';%坍塌到v2的代价
            %cost(:,3) = sum(squeeze(sum(bsxfun(@times,vm,Qbar),1)).*squeeze(vm),1)';%坍塌到中点的代价
            %输入  vi:4*1*ne    Qbar:4*4*ne
            %输出  costi：ne*1
            %统一使用边矩阵？，感觉不是很合理
            bsx=bsxfun(@times,Qbar,vi); %{Qbar:4*4*ne   vi:4*1*ne } -> 4*4*ne
            
            s=sum(bsx,1);               % 4*4*ne -> 1*4*ne
            s=permute(s, [2,1,3]);%!!!!!!!!!!!!!!!!!解决了BUG
            costi=sum(squeeze(s).*squeeze(vi),1)';
            %           s:1*4*ne  vi:4*1*ne
            % ne*1 = {  1*4*ne ,  4*1*ne  }'
            %squeeze删除了长度为 1 的维度
        end

%开始坍塌%坍塌后的空洞推测是由于重合点引起的

for i = 1:nv-np%每次删除一个顶点
    
    [min_cost, vidx] = min(cost,[],2);%返回包含每一行的最小值的列向量
    % min_cost:ne*1   vidx:ne*1
    
    [~, k] = min(min_cost);%获取代价最小的边序号
    e = E(k,:);%获取边对应的两个顶点

    % update position for v1
    V(e(1),:) = v(1:3, vidx(k), k)';%一个顶点坍塌到指定位置
    V(e(2),:) = NaN;%删除另一个顶点

    % update Q for v1  %更新代价矩阵，这里的代价之后似乎重新计算了
    Q(:,:,e(1)) = Q(:,:,e(1)) + Q(:,:,e(2));%e(1)的代价为之前两个点的代价之和
    Q(:,:,e(2)) = NaN;%e(2)的代价为空

    %更新三角面
    F(F == e(2)) = e(1);%e1、e2都是具体数值 %三角面中e2的索引现在都指向e1
    f_remove = sum(diff(sort(F,2),[],2) == 0, 2) > 0;%如果三角面中有两个相同的点就应当移除
    F(f_remove,:) = [];%需要移除的平面置为空

    %删除去除的边和与该边相关的信息 collapse and delete edge and related edge information
    E(E == e(2)) = e(1);%边中e2的索引现在都指向e1
    E(k,:) = [];%k是代价最小的边序号，置为空
    cost(k,:) = [];%修改边的代价信息
    Qbar(:,:,k) = [];%删除边对应的矩阵
    v(:,:,k) = [];%v的每行对应一条边

    %删除重复的边和与该边相关的信息 delete duplicate edge and related edge information
    [E,ia] = unique(sort(E,2), 'rows'); %E:ne*2 获取独一的行（边）
    cost = cost(ia,:);
    Qbar = Qbar(:,:,ia);%Qbar:4*4*ne
    v = v(:,:,ia);
 
    % pairs involving v1
    pair = sum(E == e(1), 2) > 0;%与e1相关的边的序号
    npair = sum(pair);%与e1相关的边的个数

    
    % updata edge information
    Qbar(:,:,pair) = Q(:,:,E(pair,1)) + Q(:,:,E(pair,2));
    %Qbar:4*4*ne  pair:n*1
    
    %{
    v_size=size(V(E(pair,1),:));%1*3会被视为3
    if v_size(1)==1
        pair_v1 = permute([V(E(pair,1),:),ones(npair,1)], [2,3,1]);
        %              n*4(*1)->4*1*n
    else
        pair_v1 = permute([V(E(pair,1),:),ones(npair,1)], [1,2,2]);
        %              4(*1)->4*1*1
    end
     %}
    
    pair_v1 = permute([V(E(pair,1),:),ones(npair,1)], [2,3,1]);
    pair_v2 = permute([V(E(pair,2),:),ones(npair,1)], [2,3,1]);
    %pair_v2:3*1*n       V(E(pair,2),:))--n*3     
    %pair_v2:3*1*1       V(E(pair,2),:))--1*3  
    pair_vm = 0.5 .* (pair_v1 + pair_v2);
    v(:,:,pair) = [pair_v1, pair_v2, pair_vm];
    
    %更新所有与e1相关的边的代价
    cost(pair,1) =get_costi(pair_v1,Qbar(:,:,pair));
    cost(pair,2) =get_costi(pair_v2,Qbar(:,:,pair));
    cost(pair,3) =get_costi(pair_vm,Qbar(:,:,pair));
    
    % cost(pair,1) =sum(squeeze(sum(bsxfun(@times,pair_v1,Qbar(:,:,pair)),1)).*squeeze(pair_v1),1)';
    % cost(pair,2) = sum(squeeze(sum(bsxfun(@times,pair_v2,Qbar(:,:,pair)),1)).*squeeze(pair_v2),1)';
    % cost(pair,3) = sum(squeeze(sum(bsxfun(@times,pair_vm,Qbar(:,:,pair)),1)).*squeeze(pair_vm),1)';
end

[ simV,simF ] = rectifyindex( V,F );

end
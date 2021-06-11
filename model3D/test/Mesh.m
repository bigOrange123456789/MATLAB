classdef Mesh < handle
    %MESH  :  3D网格对象
    %继承handel后可以在对象内部修改对象的属性
    
    properties
        V%点  nv*3
        E%线  ne*3
        F%面  nf*3
        NV%顶点法线
        NF%平面法线
        file_name%文件名称
    end
    
    methods
        function n=nv(o)
            n=size(o.V,1);
        end
        function n=ne(o)
            n=size(o.E,1);
        end
        function n=nf(o)
            n=size(o.F,1);
        end
        function obj = Mesh(file_name)
            obj.file_name=file_name;
            [obj.V,obj.F] = obj.read(file_name);
            obj.computeNormal();%计算所有平面的法线
            obj.computeEdge();
        end
        function process(this)
            myQEM=QEM();
            this=myQEM.simplification(this,0.5);
            this.download();
        end
        function download(this)
            this.write(this.file_name+"_save",this.V,this.F);
        end
        function computeNormal(o)
            %输入： vertex：nv*3   face:nf*3
            %输出：
            % compute_normal - compute the normal of a triangulation
            %
            %   [normal,normalf] = compute_normal(vertex,face);
            %
            %   normal(i,:) is the normal at vertex i.
            %   normalf(j,:) is the normal at face j.
            
            
            [vertex,face] = check_face_vertex(o.V,o.F);
            %vertex：3*nv   face:3*nf
            
            nface = size(face,2);
            nvert = size(vertex,2);
            
            % unit normals to the faces 单位面法线
            normalf = crossp( vertex(:,face(2,:))-vertex(:,face(1,:)), ...
                vertex(:,face(3,:))-vertex(:,face(1,:)) );
            d = sqrt( sum(normalf.^2,1) );
            d(d<eps)=1;%eps是极小值
            normalf = normalf ./ repmat( d, 3,1 );%面法线单位化
            
            % unit normal to the vertex
            normal = zeros(3,nvert);%顶点法线 normal:3*nv
            for i=1:nface
                f = face(:,i);
                for j=1:3
                    normal(:,f(j)) = normal(:,f(j)) + normalf(:,i);
                end
            end
            % normalize
            d = sqrt( sum(normal.^2,1) ); d(d<eps)=1;
            normal = normal ./ repmat( d, 3,1 );
            
            % enforce that the normal are outward
            v = vertex - repmat(mean(vertex,1), 3,1);
            s = sum( v.*normal, 2 );
            if sum(s>0)<sum(s<0)
                % flip
                normal = -normal;
                normalf = -normalf;
            end
            o.NV=normal';
            o.NF=normalf';
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            function z = crossp(x,y)%x,y可以看做三角形的两个边，z是和它们垂直的方向
                % x and y are (m,3) dimensional
                z = x;
                z(1,:) = x(2,:).*y(3,:) - x(3,:).*y(2,:);
                z(2,:) = x(3,:).*y(1,:) - x(1,:).*y(3,:);
                z(3,:) = x(1,:).*y(2,:) - x(2,:).*y(1,:);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            function [vertex,face] = check_face_vertex(vertex,face)
                
                % check_face_vertex - check that vertices and faces have the correct size
                %
                %   [vertex,face] = check_face_vertex(vertex,face);
                %
                %   Copyright (c) 2007 Gabriel Peyre
                
                vertex = check_size(vertex,2,4);
                face = check_size(face,3,4);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            function a = check_size(a,vmin,vmax)
                if isempty(a)
                    return;
                end
                if size(a,1)>size(a,2)
                    a = a';
                end
                if size(a,1)<3 && size(a,2)==3
                    a = a';
                end
                if size(a,1)<=3 && size(a,2)>=3 && sum(abs(a(:,3)))==0
                    % for flat triangles
                    a = a';
                end
                if size(a,1)<vmin ||  size(a,1)>vmax
                    error('face or vertex is not of correct size');
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end%函数结束
        function computeEdge(o)
            TR = triangulation(o.F,o.V);%进行三角剖分，梳理出所有三角形
            o.E = edges(TR);%返回所有边的顶点索引  ne*2
        end
        function rectifyindex(o)
            %清除为空的顶点
            %RECTIFYINDEX Summary of this function goes here
            
            
            num_of_NaN=zeros(o.nv(),1);
            sum=0;
            for i=1:o.nv()
                if isnan(o.V(i,1)) % 为空 NaN
                    sum=sum+1;
                end
                num_of_NaN(i)=sum;
            end
            
            recF=zeros(o.nf(),3);%三角面个数不变，但是由于顶点个改变，三角面的顶点索引需要修改
            for i=1:o.nf()
                for j=1:3
                    recF(i,j)=o.F(i,j)-num_of_NaN(o.F(i,j));
                end
            end
            
            recV=zeros(o.nv-sum,3);%总个数-为空的个数
            j=1;
            for i=1:o.nv()
                if ~isnan(o.V(i,1))
                    recV(j,:)=o.V(i,:);
                    j=j+1;
                end
            end
            o.V=recV;
            o.F=recF;
        end
            
    end%methods
    methods(Static)
        function [vertex,faces] = read(filename)
            vertex = [];
            faces = [];
            fid = fopen(filename+".obj");%fid是一个大于0的整数
            while 1
                s = fgetl(fid);
                if ~ischar(s) %如果不是字符串，退出，空字符串也是字符串
                    break;
                elseif ~isempty(s)
                    if strcmp(s(1), 'f')%如果字符串第一个字符为f %face
                        faces(end+1,:) = sscanf(s(3:end), '%d %d %d');
                    elseif strcmp(s(1), 'v')%如果字符串第一个字符为v %vertex
                        vertex(end+1,:) = sscanf(s(3:end), '%f %f %f');
                    end%vertex添加一行、在最后一列  s从第三个字符开始到最后一个
                end
            end
            fclose(fid);
        end
        function write(filename,vertices,faces )
            fid=fopen(filename+".obj",'w');
            fid=arrPrintf(fid,vertices,'v');
            fid=arrPrintf(fid,faces,'f');
            fclose(fid);
            function fid=arrPrintf(fid,arr,head)
                [x,y]=size(arr);
                for i=1:x
                    fprintf(fid,head);
                    for j=1:y
                        fprintf(fid,' %d',arr(i,j));
                    end
                    fprintf(fid,'\n');%每一行回车\n  
                end
            end
        end
        function test()
            mesh=Mesh("test");
            myQEM=QEM();
            mesh=myQEM.simplification(mesh,0.3);
            mesh.download();
        end
    end%methods(Static)
end%class

classdef Mesh < handle
    %MESH  :  3D�������
    %�̳�handel������ڶ����ڲ��޸Ķ��������
    
    properties
        V%��  nv*3
        E%��  ne*3
        F%��  nf*3
        NV%���㷨��
        NF%ƽ�淨��
        file_name%�ļ�����
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
            obj.computeNormal();%��������ƽ��ķ���
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
            %���룺 vertex��nv*3   face:nf*3
            %�����
            % compute_normal - compute the normal of a triangulation
            %
            %   [normal,normalf] = compute_normal(vertex,face);
            %
            %   normal(i,:) is the normal at vertex i.
            %   normalf(j,:) is the normal at face j.
            
            
            [vertex,face] = check_face_vertex(o.V,o.F);
            %vertex��3*nv   face:3*nf
            
            nface = size(face,2);
            nvert = size(vertex,2);
            
            % unit normals to the faces ��λ�淨��
            normalf = crossp( vertex(:,face(2,:))-vertex(:,face(1,:)), ...
                vertex(:,face(3,:))-vertex(:,face(1,:)) );
            d = sqrt( sum(normalf.^2,1) );
            d(d<eps)=1;%eps�Ǽ�Сֵ
            normalf = normalf ./ repmat( d, 3,1 );%�淨�ߵ�λ��
            
            % unit normal to the vertex
            normal = zeros(3,nvert);%���㷨�� normal:3*nv
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
            function z = crossp(x,y)%x,y���Կ��������ε������ߣ�z�Ǻ����Ǵ�ֱ�ķ���
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
        end%��������
        function computeEdge(o)
            TR = triangulation(o.F,o.V);%���������ʷ֣����������������
            o.E = edges(TR);%�������бߵĶ�������  ne*2
        end
        function rectifyindex(o)
            %���Ϊ�յĶ���
            %RECTIFYINDEX Summary of this function goes here
            
            
            num_of_NaN=zeros(o.nv(),1);
            sum=0;
            for i=1:o.nv()
                if isnan(o.V(i,1)) % Ϊ�� NaN
                    sum=sum+1;
                end
                num_of_NaN(i)=sum;
            end
            
            recF=zeros(o.nf(),3);%������������䣬�������ڶ�����ı䣬������Ķ���������Ҫ�޸�
            for i=1:o.nf()
                for j=1:3
                    recF(i,j)=o.F(i,j)-num_of_NaN(o.F(i,j));
                end
            end
            
            recV=zeros(o.nv-sum,3);%�ܸ���-Ϊ�յĸ���
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
            fid = fopen(filename+".obj");%fid��һ������0������
            while 1
                s = fgetl(fid);
                if ~ischar(s) %��������ַ������˳������ַ���Ҳ���ַ���
                    break;
                elseif ~isempty(s)
                    if strcmp(s(1), 'f')%����ַ�����һ���ַ�Ϊf %face
                        faces(end+1,:) = sscanf(s(3:end), '%d %d %d');
                    elseif strcmp(s(1), 'v')%����ַ�����һ���ַ�Ϊv %vertex
                        vertex(end+1,:) = sscanf(s(3:end), '%f %f %f');
                    end%vertex���һ�С������һ��  s�ӵ������ַ���ʼ�����һ��
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
                    fprintf(fid,'\n');%ÿһ�лس�\n �0�2
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

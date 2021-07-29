classdef SH < handle
    %SH 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        ff
        degree
        num
    end
    
    methods
        function o= SH
            o.ff=optimset;%optimset 设置优化的结构体
            o.ff.MaxFunEvals=50000;%'MaxFunEvals' - 函数计算的最大次数
            o.ff.MaxIter=5000;%'MaxIter' - 最大迭代次数
            o.degree=2;
            o.num=sum(1:o.degree+1);
        end
        function cc = fit(o,data)
            %data: n*3  %x,y,z %FEATURE 此处显示有关此函数的摘要 %此处显示详细说明
            x=data(:,1);
            y=data(:,2);
            z=data(:,3);
            
            [a,e,r]=cart2sph(x,y,z);
            
            %l=2; %degree %num=o.num;%(l+2)*(l+1)/2;%l+1的前n项和 %对于ｌ阶的展开，一共有多少项
            x0=zeros(1,2*o.num);%乘以2应该是考虑虚部  %系数初值为０;
            
            lb=[];ub=[];
            [cc,~,~] = lsqcurvefit(@o.myfunhopeho,x0,[cos(a');e'],r',lb,ub,o.ff);
        end
        function y=myfunhopeho(o,cc,X)
            %cc是系数:1*2n
            %X: 2*10000  %Y: 1*10000
            %l=2;%degree
            y=zeros(1,length(X));
            x2=X(2,:);
            for j=0:o.degree
                p=legendre(j,X(1,:));%p: j*rx    连带legend函数
                %为 X 中的每个元素计算 连带 Legendre 函数。
                %阶数为 n、级数为0, 1, ..., n
                
                i1=cc(sum(1:j)*2+1:sum(1:j)*2+j);%数组长度为j
                i2=cc(sum(1:j)*2+j+1:sum(1:j+1)*2);%数组长度为j
                v1=cos((0:j).*x2);
                v2=sin((0:j).*x2);
                y=y+(i1*v1+i2*v2).*p;
            end
        end%myfunhopeho
        function y=myfunhopeho0(o,cc,X)
            %cc是系数:1*2n
            %X: 2*10000
            %Y: 1*10000
            %l=2;%degree
            
            indexm=zeros(1,o.num);
            k=1;
            for i=0:o.degree
                for j=0:i
                    indexm(k)=j;
                    k=k+1;
                end
            end
            
            pp=zeros(o.num,length(X));
            y=0;
            x2=X(2,:);
            for j=0:o.degree
                begin=sum(1:j)+1;
                pp(begin:begin+j,:)=legendre(j,X(1,:));
                %p: j*rx    连带legend函数
                %为 X 中的每个元素计算 连带 Legendre 函数。
                %阶数为 n、级数为0, 1, ..., n
                
                i1=cc(sum(1:j)*2+1:sum(1:j)*2+j);%数组长度为j
                i2=cc(sum(1:j)*2+j+1:sum(1:j+1)*2);%数组长度为j
                v1=cos((0:j).*x2);
                v2=sin((0:j).*x2);
                y=y+(i1*v1+i2*v2).*pp(begin:begin+j,:);
            end
            
            
            for  k=1:o.num %各个基的加权和
                i1=cc(2*k-1);
                i2=cc(2*k);
                v1=cos(indexm(k)*x2);
                v2=sin(indexm(k)*x2);
                y=y+(i1*v1+i2*v2).*pp(k,:);
            end
            
        end%myfunhopeho
    end
    methods(Static)
        function vector=getFeature(mesh)
            voxel=mesh.voxelization();
            mean0 = mean(voxel);% 样本均值
            Z = voxel-repmat(mean0,length(voxel), 1);%减去均值
            
            mySH=SH();
            vector=mySH.fit(Z);
        end
    end%methods(Static)
end


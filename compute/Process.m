classdef Process
    %PROCESS 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        fileNames
        vectors
        distances
    end
    
    methods
        function o = Process()
            delete("result.xlsx");
            %PROCESS 构造此类的实例
            %   此处显示详细说明
            [o.fileNames,o.vectors]=Process.read("5.txt");
            writecell(o.fileNames','result.xlsx','Sheet',1,'Range','A1');
            
            %o.fileNames=fileNames;
            %o.vectors=vectors;
            o.distances=Process.distance(o.vectors);
            
            mat=o.distances==0;
            mat=mat-diag(diag(mat));
            disp(sum(mat,"all")/2);
            disp(sum(mat,"all")/((length(mat)^2)*2));
            mat=gather(mat);
            
            %result=mat2cell(result);
            %xlswrite('result.xlsx', result);
            %xlswrite('names.xlsx',(o.fileNames)');
            
            result2=1:length(mat);
            %c1=mat2cell(o.fileNames',length(o.fileNames'));
            %c2=mat2cell( (1:length(result))',length(result));
            %console=[c1';c2']';
            %size(console)
            for j1=1:length(mat)-1
                if j1==result2(j1)%是一个原模型
                    for j2=j1+1:length(mat)
                        if mat(j1,j2)==1%相似
                            result2(j2)=j1;
                        end
                    end
                end
            end
            writematrix(result2','result.xlsx','Sheet',1,'Range','B1');
            
            
            
        end
        
        
    end
    methods(Static)
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
        function [fileNames,mat] = read(path)
            
            fileFolder=fullfile(path);
            dirOutput=dir(fullfile(fileFolder,'*.txt'));
            fileNames={dirOutput.name};
            c=544;
            mat=zeros(length(fileNames),c);
            for i=1:length(fileNames)
                disp(i);
                arr=getArr( path+"/"+ string(fileNames(i)) );
                mat(i,:)=arr(1,c);
            end
            
            function arr=getArr(path0)
                fid = fopen(path0);%fid是一个大于0的整数
                fgetl(fid);
                str = fgetl(fid);
                arr=strsplit(str," ");
                arr(1)=[];
                arr=str2double(arr);
                fclose(fid);
            end
            
        end
    end
end


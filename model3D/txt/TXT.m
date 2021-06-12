classdef TXT
    %TXT 
    
    properties
    end
    
    methods
        function o= TXT()
        end
    end
    
    methods(Static)
        function test()
            TXT.print("1.txt")
        end
        function print(filename)
            fid = fopen(filename);%fid是一个大于0的整数
            while 1
                s = fgetl(fid);
                if ~ischar(s) %如果不是字符串，退出，空字符串也是字符串
                    break;
                end
                display(s);
            end
            fclose(fid);
        end
        function [vertex,faces] = read(filename)
            vertex = [];
            faces = [];
            fid = fopen(filename);%fid是一个大于0的整数
            while 1
                s = fgetl(fid);
                if ~ischar(s) %如果不是字符串，退出，空字符串也是字符串
                    break;
                elseif ~isempty(s)
                    if strcmp(s(1), 'f')%如果字符串第一个字符为f %face
                        %  F V1 V2 V3 ...
                        %  F V1/VT1/VN1  ...
                        %  F V1//VN1  ...
                        
                        faces(end+1,:) = sscanf(s(3:end), '%d %d %d');
                    elseif strcmp(s(1), 'v')%如果字符串第一个字符为v %vertex
                        vertex(end+1,:) = sscanf(s(3:end), '%f %f %f');
                    end%vertex添加一行、在最后一列  s从第三个字符开始到最后一个
                end
            end
            fclose(fid);
        end
        function write(filename,vertices,faces )
            fid=fopen(filename,'w');
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
    end%methods(Static)
end


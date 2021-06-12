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
            fid = fopen(filename);%fid��һ������0������
            while 1
                s = fgetl(fid);
                if ~ischar(s) %��������ַ������˳������ַ���Ҳ���ַ���
                    break;
                end
                display(s);
            end
            fclose(fid);
        end
        function [vertex,faces] = read(filename)
            vertex = [];
            faces = [];
            fid = fopen(filename);%fid��һ������0������
            while 1
                s = fgetl(fid);
                if ~ischar(s) %��������ַ������˳������ַ���Ҳ���ַ���
                    break;
                elseif ~isempty(s)
                    if strcmp(s(1), 'f')%����ַ�����һ���ַ�Ϊf %face
                        %  F V1 V2 V3 ...
                        %  F V1/VT1/VN1  ...
                        %  F V1//VN1  ...
                        
                        faces(end+1,:) = sscanf(s(3:end), '%d %d %d');
                    elseif strcmp(s(1), 'v')%����ַ�����һ���ַ�Ϊv %vertex
                        vertex(end+1,:) = sscanf(s(3:end), '%f %f %f');
                    end%vertex���һ�С������һ��  s�ӵ������ַ���ʼ�����һ��
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
                    fprintf(fid,'\n');%ÿһ�лس�\n �0�2
                end
            end
        end
    end%methods(Static)
end


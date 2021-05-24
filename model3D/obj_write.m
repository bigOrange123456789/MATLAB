function []=obj_write(filename,vertices,faces )
%TEST Summary of this function goes here  
%  write matrix to file  

vertices=vertices';
faces=faces';
fid=fopen(filename,'a');  
  
[x,y]=size(vertices);  
  
 for i=1:x
    fprintf(fid,'v ');
    for j=1:y-1  
        fprintf(fid,'%f ',vertices(i,j));  
    end  
    fprintf(fid,'%f\r\n',vertices(i,y));%每一行回车\n  
    %fprintf(fid,'\n');%每一行回车\n  
 end 

fprintf(fid,'\n');%每一行回车\n  

[x,y]=size(faces);  
  
 for i=1:x
    fprintf(fid,'f ');
    for j=1:y-1  
        fprintf(fid,'%d ',faces(i,j));  
    end  
    fprintf(fid,'%d\r\n',faces(i,y));%每一行回车\n  
    %fprintf(fid,'\n');%每一行回车\n  
end 
  
fclose(fid);  
  
  
end
%https://blog.csdn.net/lafengxiaoyu/article/details/63278451

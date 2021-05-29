function objWrite(filename,vertices,faces )
fid=fopen(filename+".obj",'w'); 
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
%https://blog.csdn.net/u013925378/article/details/107181734
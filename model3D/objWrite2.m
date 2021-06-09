function objWrite2(filename,vertices,faces )
fid=fopen(filename+".obj",'w'); 
fid=arrPrintf(fid,vertices,'v');
fid=arrPrintf(fid,faces,'f');
fclose(fid); 
end
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
%https://blog.csdn.net/u013925378/article/details/107181734
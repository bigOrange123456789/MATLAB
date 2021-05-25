function result=f()
%disp(1)
%data=importdata()('list2.txt')

%fid=fopen('list2.txt','r')
%fgets(fid);
%fclose(fid);
 a=textread('list2.txt','%s%*[^\n]') ;
 
 l=length(a(:));
 
 result=cell(l/5,5);
 
 for i=1:l/5,
     for j=1:5,
         result(i,j)=a(5*(i-1)+j);    
     end;
     
 end;
 
 b=[1,1];
 for i=0:3,
     for j=0:2,
         
     end;
 end;
 b=[b,1];
 
end
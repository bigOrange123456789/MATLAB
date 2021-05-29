function test3()
[v]=objRead("man3");

k=0;%重复出现的顶点个数
for i=1:length(v)
    flag=0;%i号顶点的重复次数
    for j=i+1:length(v)
        if v(i,1)==v(j,1)&&v(i,2)==v(j,2)&&v(i,3)==v(j,3)
            flag=flag+1;
        end
    end
    if flag~=0 ,k=k+1;end
end
display(k);

v_index=zeros(length(v),1);
v_new=zeros(length(v)-k,3);
for i=1:length(v)
    flag=0;
    for j=i+1:length(v)
        if v(i,1)==v(j,1)&&v(i,2)==v(j,2)&&v(i,3)==v(j,3)
            flag=flag+1;
        end
    end
    %display(i+":"+flag);
    if flag==0 
        k=k+1;
        v_new(k,1)=v(i,1);
        v_new(k,2)=v(i,2);
        v_new(k,3)=v(i,3);
    end
    v_index(k)=i;
end
%display(v_index);
%display(size(v_index));
%display(v_new);

end
function  txtHandle()
fid=fopen('list.txt','w','n','Shift_JIS')
%fid=fopen('test2.txt','r');
a=fgets(fid)

fclose(fid);
%class(a)
arr = regexp(a,' ', 'split')
arr(2)

end

function  txtHandle2()

fid=fopen('test2.txt','r');
a=fgets(fid)
a

fclose(fid);
%class(a)


sub = fopen('test2.txt');
data = textscan(sub,'%s');
fclose(sub)

end




function test000()
data=importdata('test2.txt');
data
end
%{
data=data(1);
arr = regexp(data,' ', 'split')

x=arr{1}
x(1)




data=importdata('test.txt');
s2=data(2);
arr = regexp(s2,' ', 'split')

x=arr{1}
%}
%class(x)




%{
for k=1:1,
    %arr{1,k}
end;

disp(arr);
%data=int2str(data);
disp(data);



class(data)%查看数据类型
%}


%arr = regexp(data,' ', 'split')%其中str是待分割的字符串，char是作为分隔符的字符（可以使用正则表达式）。分割出的结果存在S中。
%disp(arr);
%file=fopen('D:\myCode\MATLABworkspase\txt\data.txt','w');
%fprintf(file,'%d',data);


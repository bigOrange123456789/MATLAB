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



class(data)%�鿴��������
%}


%arr = regexp(data,' ', 'split')%����str�Ǵ��ָ���ַ�����char����Ϊ�ָ������ַ�������ʹ��������ʽ�����ָ���Ľ������S�С�
%disp(arr);
%file=fopen('D:\myCode\MATLABworkspase\txt\data.txt','w');
%fprintf(file,'%d',data);


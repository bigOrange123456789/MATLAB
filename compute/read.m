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
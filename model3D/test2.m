function test2()
%[v,f]=objRead("test");
%objWrite("test2",v,f);
myRead()
end
function myRead()
fid = fopen("1.txt");%打开文件

fclose(fid);

fid = fopen("test.obj");%打开文件
vertex = [];
faces = [];
while 1
   s = fgetl(fid);
  if ~ischar(s) 
         break;
  end
   if ~isempty(s) && strcmp(s(1), 'f')
    % face
   faces(:,end+1) = sscanf(s(3:end), '%d %d %d');
   end
  if ~isempty(s) && strcmp(s(1), 'v')
     % vertex
     vertex(:,end+1) = sscanf(s(3:end), '%f %f %f');
  end
end
fclose(fid);

end
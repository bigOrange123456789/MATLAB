function [vertex,faces] = objRead(filename)

fid = fopen(filename+".obj");
if fid<0
  error(['Cannot open ' filename '.']);
end

frewind(fid);
a = fscanf(fid,'%c',1);
if strcmp(a, 'P')%如果第一个字符为P
   fscanf(fid,'%f',5);
   n_points=fscanf(fid,'%i',1);
  vertex=fscanf(fid,'%f',[3,n_points]);
   normal=fscanf(fid,'%f',[3,n_points]);
   n_faces=fscanf(fid,'%i',1);
  fscanf(fid,'%i',5+n_faces);
   faces=fscanf(fid,'%i',[3,n_faces])'+1;
   fclose(fid);
   return;
end

frewind(fid);
vertex = [];
faces = [];
while 1
  s = fgetl(fid);
  if ~ischar(s) %如果不是字符串，退出，空字符串也是字符串
         break;
  elseif ~isempty(s)
        if strcmp(s(1), 'f')%如果字符串第一个字符为f %face
            faces(:,end+1) = sscanf(s(3:end), '%d %d %d');
        elseif strcmp(s(1), 'v')%如果字符串第一个字符为v %vertex
            vertex(:,end+1) = sscanf(s(3:end), '%f %f %f');
        end%vertex添加一行、在最后一列  s从第三个字符开始到最后一个
  end
end
fclose(fid);
vertex=vertex';
faces=faces';

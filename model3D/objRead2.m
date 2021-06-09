function [vertex,faces] = objRead2(filename)
vertex = [];
faces = [];
fid = fopen(filename+".obj");%fid是一个大于0的整数
while 1
  s = fgetl(fid);
  if ~ischar(s) %如果不是字符串，退出，空字符串也是字符串
         break;
  elseif ~isempty(s)
        if strcmp(s(1), 'f')%如果字符串第一个字符为f %face
            faces(end+1,:) = sscanf(s(3:end), '%d %d %d');
        elseif strcmp(s(1), 'v')%如果字符串第一个字符为v %vertex
            vertex(end+1,:) = sscanf(s(3:end), '%f %f %f');
        end%vertex添加一行、在最后一列  s从第三个字符开始到最后一个
  end
end
fclose(fid);


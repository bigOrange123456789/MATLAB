function ch = A2a(ch)
%A2A 此处显示有关此函数的摘要
%   此处显示详细说明
if class(ch)=="cell"
    ch=cell2mat(ch);
    k=find(ch>='A' & ch<='Z');
    ch(k)=ch(k)-'A'+'a';
    ch={ch};
else 
    k=find(ch>='A' & ch<='Z');
    ch(k)=ch(k)-'A'+'a';
end
end


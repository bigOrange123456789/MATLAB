function ch = A2a(ch)
%A2A �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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


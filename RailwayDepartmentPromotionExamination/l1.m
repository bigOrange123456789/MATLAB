function [s,flag]=l1(a0,aa,ab,ac,ad,ae,l2)

    b=l2;

    A=['A','.',aa(b,:)];
    B=['B','.',ab(b,:)];
    C=['C','.',ac(b,:)];
    D=['D','.',ad(b,:)];

    
    disp(a0(b,:));
    disp(A);
    disp(B);
    disp(C);
    disp(D);
    
    s=input('','s');
    flag=0;%不移除
    if length(s)~=0,
        if s(1)=='-',
            disp('已从错题集中移除。');flag=1;
        elseif s(1)==ae(b),
            disp('答对了，已从错题集中移除。');flag=1;
        end;
    end;
    disp(['错了，答案是',ae(b)]);
    %disp('题目编号：');
    %disp(b);
    %disp('答案为：');
    %disp(ae(b));



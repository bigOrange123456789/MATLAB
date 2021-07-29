function test( )
            arr={};
            fid = fopen("test1.ifc");%fid是一个大于0的整数
            s = fgetl(fid);
            while ischar(s)
                ch=char(s);
                if ~isempty(s)&&ch(1)=="#"
                    a=strsplit(s,"IFC");
                    s=cell2mat(a(2));
                    a=strsplit(s,"(");
                    disp(a(1))
                    s=A2a( a(1) );
                    arr(end+1,1)=s;
                end
                s = fgetl(fid);%获取下一行
            end
            fclose(fid);
            %writecell(arr,'arr.xlsx','Sheet',1,'Range','A1');
            
            l=length(arr);
            analysis=ones(l,1);
            for i=2:l
                for j=1:i
                    if string(arr(i))==string(arr(j))
                        analysis(j,1)=analysis(j,1)+1;
                        analysis(i,1)=analysis(i,1)-1;
                        break;
                    end
                end
                disp(i/l);
            end
            writematrix(analysis,'arr.xlsx','Sheet',1,'Range','B1');
end

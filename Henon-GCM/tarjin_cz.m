function tarjin_cz(label,I,C)
%利用targin算法求有向图的强连通子图，输入的C就是一个邻接结构，每一行都是每个顶点的邻接表

global DFN LOW Ncom stccom stack isstack num top
DFN(label,1)=num;
LOW(label,1)=num;
num=num+1;
top=top+1;
stack(top,1)=label;%放入栈中
isstack(label,1)=1;%放入栈中

for i=1:I(label,1)
    w=C(label,i);
    if DFN(w,1)==0 %若label的第i个像是未访问过的
        tarjin_cz(w,I,C);%递归调用tarjin
        LOW(label,1)=min(LOW(label,1),LOW(w,1));
    elseif DFN(w,1)<DFN(label,1)
        if isstack(w,1)==1%若label的第i个像是访问过的且在栈中
            LOW(label,1)=min(LOW(label,1),DFN(w,1));
        end
    end
end

if LOW(label,1)==DFN(label,1)
    Ncom=Ncom+1;%找到一个新的强连通子图
    while 1
%         top=top-1;
        j=stack(top,1);
        stccom(j,1)=Ncom;
        stack(top,1)=0;%元素出栈
        isstack(j,1)=0;%元素出栈
        top=top-1;%栈中元素减少一个
        if j==label||top<=0
            break;
        end
    end
end

    
        




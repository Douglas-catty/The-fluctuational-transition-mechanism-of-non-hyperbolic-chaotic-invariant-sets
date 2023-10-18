function [SC,Bcnt] = tarjin(G)
%用DFS-Tarjin算法搜索邻接矩阵中的强连通子图
%输入G为邻接矩阵，输出1by(Nx*Ny+1)的矩阵和强连通子图的个数，属于相同强连通子图的标示为相同数字标号

%初始化
n=size(G,1);
W=G;%用于记录边是否访问过
point=1;%从标号为1的点开始DFS
DFN=zeros(1,n);%访问顺序，时间戳
LOW=zeros(1,n);%次序号，LOW(u)=min(DFN(u),LOW(v),DFN(v))
f=zeros(1,n);%记录父顶点
stack=zeros(1,n);%栈
instack=zeros(1,n);%是否在栈中
b=sum(sum((W==1)));%待处理的边数
c=sum(DFN==0);%待处理的顶点
d=1;%循环判别数
top=1;%栈的顶点位置
Bcnt=0;%强连通子图的个数
SC=zeros(1,n);%强连通子图的分布

%DFS-Tarjin算法
if b==0&&c==0&&point==1
    d=0;%终止循环
end

%从第一点开始搜索，初始化
DFN(point)=1;
numpoint=2;%访问顶点的顺序变量
numedge=2;%访问边的顺序变量
stack(top)=point;top=top+1;
instack(point)=1;

while d
    b=sum(sum((W==1)));
    c=sum(DFN==0);
    if b==0&&c==0&&point==1 %终止条件
        d=0;
    end
    if isempty(find(SC==0,1))
        return;
    end
    
    a=find(W(point,:)==1);
    if isempty(a)
        if f(point)~=0
            W(f(point),point)=numedge;numedge=numedge+1;
        end
        if LOW(point)==0
            LOW(point)=DFN(point);
        end
        if DFN(point)==LOW(point)&&instack(point)%判断是否为强连通子图
            Bcnt=Bcnt+1;
            n=stack(top-1);top=top-1;
            instack(n)=0;%出栈
            SC(n)=Bcnt;
            while n~=point
                n=stack(top-1);top=top-1;
                instack(n)=0;%出栈
                SC(n)=Bcnt;
            end
        end
        if f(point)~=0%????
            if LOW(f(point))==0&&isempty(find(W(f(point),:)==1,1))
                LOW(f(point))=min(DFN(f(point)),LOW(point));
            end
        end
        
        %出栈后应该进入父胞，但是有特殊情况：1、无父胞，2、父胞是自己(已出栈），3、进入吸引子，父胞循环（已出栈）

        if sum(instack)==0&&~isempty(find(SC==0,1))%一开始就进吸引子（已出栈）情况
            point=find(SC==0,1);
            DFN(point)=numpoint;
            numpoint=numpoint+1;
            stack(top)=point;top=top+1;
            instack(point)=1;    
        elseif f(point)==0&&~isempty(find(SC==0,1))%无父胞情况
            temp=point;in=1;
            while temp~=point
                point=find(SC==0,in);
                point=point(in);
                in=in+1;
            end
            DFN(point)=numpoint;
            numpoint=numpoint+1;
            stack(top)=point;top=top+1;
            instack(point)=1;
        elseif f(point)~=0&&~instack(f(point))&&~isempty(find(SC==0,1))%途中进入吸引子的情况
            point=stack(top-1);
        else%正常情况
            point=f(point);
        end
    else
        for i=1:length(a)
            if DFN(a(i))==0%point 未访问过
                DFN(a(i))=numpoint;
                numpoint=numpoint+1;
                W(point,a(i))=numedge;numedge=numedge+1;
                f(a(i))=point;
                point=a(i);
                stack(top)=a(i);top=top+1;
                instack(a(i))=1;
                break;
            elseif DFN(a(i))~=0%point已经访问过
                W(point,a(i))=numedge;numedge=numedge+1;
                if instack(a(i))&&a(i)~=point%后向边
                    if LOW(point)==0%单后向边
                        LOW(point)=min(DFN(a(i)),DFN(point));
                    elseif LOW(point)~=0%多后向边
                        LOW(point)=min(DFN(a(i)),LOW(point));
                    end
                    if LOW(point)==DFN(point)
                        break;
                    end
                    %处理树枝边
                    tempf=f(point);
                    temps=point;
                    temped=a(i);
                    while tempf~=0&&tempf~=temped
                        if LOW(tempf)==0%单后向边
                            LOW(tempf)=min(DFN(tempf),LOW(temps));
                        elseif LOW(tempf)~=0%多后向边
                            LOW(tempf)=min(LOW(tempf),LOW(temps));
                        end
                        if LOW(tempf)==DFN(tempf)
                            break;
                        end
                        temps=tempf;
                        tempf=f(temps);
                    end
                end
                if a(i)~=point&&~instack(a(i))%不记录自己是自己父胞的情况和后向边的情况
                    f(a(i))=point;
                end
            end
        end
    end
end

end


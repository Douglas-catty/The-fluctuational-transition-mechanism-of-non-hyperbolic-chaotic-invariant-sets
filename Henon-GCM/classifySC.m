function CSC = classifySC(G,SC,Bcnt)
%简单的将强连通域分为第一类、第二类、第三类顶点
%   输出第一类、第二类、第三类顶点分别以正数，负数，0标记，相同标记属于同一组顶点
%   输入G为邻接矩阵，SC为强连通域标记矩阵，Bcnt为强连通域个数

cnt1=1;%三个集合的标记器
cnt2=-1;
cnt3=0;
n=size(G,1);
CSC=zeros(1,n);%初始化

for i=1:Bcnt
    label=0;%标记
    a=find(SC==i);
    if length(a)==1
        b=find(G((a),:)==1);
        if isempty(b)
            CSC(a)=cnt1;
            cnt1=cnt1+1;
        elseif ~isempty(find(b==a,1))&&length(b)==1
            CSC(a)=cnt1;
            cnt1=cnt1+1;
        elseif ~isempty(find(b==a,1))&&length(b)~=1
            CSC(a)=cnt2;
            cnt2=cnt2-1;
        else 
            continue;
        end
        continue;
    end
    for j=1:length(a)
        b=find(G(a(j),:)==1);
        for k=1:length(b)
            if SC(b(k))~=i
                label=1;
                break;
            end
        end
        if label==1
            CSC(a)=cnt2;
            cnt2=cnt2-1;
            break;
        end
    end
    if label==0
        CSC(a)=cnt1;
        cnt1=cnt1+1;
    end
end

end


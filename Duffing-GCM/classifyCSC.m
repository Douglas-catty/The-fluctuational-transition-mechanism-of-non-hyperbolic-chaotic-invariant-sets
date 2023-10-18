function CCSC = classifyCSC(G,CSC)
%   将第二类顶点分为鞍点和不稳定解
%   鞍点标记为负数，不稳定解标记为0！！！没有分析出不稳定解
%   输入G为邻接矩阵，SC为强连通域标记矩阵，Bcnt为强连通域个数

cntsa=-1;
cntus=0;
m=-min(CSC);
n=size(G,1);
CCSC=CSC;%初始化

for i=1:m
    label=0;%标记
    a=find(CCSC==-i);
    for j=1:length(a)
        b=find(G(:,a(j))==1);
        for k=1:length(b)
            if CCSC(b(k))~=-i
                label=1;
                break;
            end
        end
        if label==1
            CCSC(a)=cntsa;
            cntsa=cntsa-1;
            break;
        end
    end
    if label==0
        CCSC(a)=cntus;
%         cntus=cntus+1;
    end
end

end


function y= SC2routing(G,CSC)
%找到以第二类顶点为路由的第三类顶点
%输出y为将CSC中以记号为n的第二类顶点为路由的第三类顶点的标号为n.5

m=-min(CSC);%不稳定强连通子图个数
%初始化
y=zeros(m,size(G,1));
for i=1:m
    y(i,:)=CSC;
end
temp=zeros(1,size(G,1));%临时记录矩阵

for i=1:m
    a=find(CSC==-i);
    while ~isempty(a)
        for j=1:length(a)
            b=find(G(a(j),:)==1);
            for k=1:length(b)
                if y(i,b(k))~=0;
                    continue;
                elseif y(i,b(k))==0
                    y(i,b(k))=-i-0.5;
                    temp(b(k))=1;
                end
            end
        end
        a=find(temp==1);
        temp=zeros(1,size(G,1));
    end
end


end


function  y= stop2SC(G,CSC)
%找到以第一或第二类顶点为驻足的第三类顶点
%输出y为将CSC中以记号为n的第一类或第二类顶点为驻足的第三类顶点的标号为n.1

n=max(CSC);%稳定强连通子图个数
m=-min(CSC);%不稳定强连通子图个数
%初始化
y=zeros(n+m,size(G,1));
for i=1:n+m
    y(i,:)=CSC;
end
temp=zeros(1,size(G,1));%临时记录矩阵

%处理第一类顶点的驻足
for i=1:n
    a=find(CSC==i);
    while ~isempty(a)
        for j=1:length(a)
            b=find(G(:,a(j))==1);
            for k=1:length(b)
                if y(i,b(k))~=0;
                    continue;
                elseif y(i,b(k))==0
                    y(i,b(k))=i+0.1;
                    temp(b(k))=1;
                end
            end
        end
        a=find(temp==1);
        temp=zeros(1,size(G,1));
    end
end

%处理第二类顶点
for i=1:m
    a=find(CSC==-i);
    while ~isempty(a)
        for j=1:length(a)
            b=find(G(:,a(j))==1);
            for k=1:length(b)
                if y(n+i,b(k))~=0;
                    continue;
                elseif y(n+i,b(k))==0
                    y(n+i,b(k))=-i-0.1;
                    temp(b(k))=1;
                end
            end
        end
        a=find(temp==1);
        temp=zeros(1,size(G,1));
    end
end

end


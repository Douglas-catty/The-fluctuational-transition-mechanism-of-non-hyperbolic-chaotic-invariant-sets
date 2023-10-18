function label_new= labelold2labelnew(label_old,Gama,Nn)
%LABELOLD2LABELNEW 自迭代细分后的标号调整
%   label_old 为细分前的标号
%   label_new 为细分后的标号，如果label_old为细分胞则输出的label_new为old胞内最小的标号
%   Gama为需要细化的胞的标号，Nn为细化程度

sort=sortold(label_old,Gama);%排序顺序
n=sum(Gama);

if sort<=n%label_old是细化胞
    label_new=(sort-1)*Nn*Nn+1;
else %label_old非细化胞
    pos=Gama==0;
    label_new=n*Nn*Nn+sum(pos(1:label_old));
end

end


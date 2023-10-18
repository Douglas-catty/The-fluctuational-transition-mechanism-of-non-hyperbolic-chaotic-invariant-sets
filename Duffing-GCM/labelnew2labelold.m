function label_old= labelnew2labelold(label_new,Gama,Nn)
%LABELOLD2LABELNEW 自迭代细分后的标号调整
%   label_old 为细分前的标号
%   label_new 为细分后的标号
%   Gama为需要细化的胞的标号，Nn为细化程度

n=sum(Gama);

if label_new<=n*Nn*Nn%细化胞中的胞
    sort=ceil(label_new/Nn/Nn);
    label_old=find(Gama==1);
    label_old=label_old(sort);
else %非细化胞
    sort=label_new-n*Nn*Nn+n;%排标号的顺序
    label_old=find(Gama==0);
    label_old=label_old(sort-n);
end
    

end


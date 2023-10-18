function cell_new= label2cellnew(label_new,xrange,yrange,Nx,Ny,Gama,Nn)
%LABEL2CELLPRO 返回自迭代下标号的cell_new范围
%label_new为输入的细化后的标号，不能输入陷胞标号
%xrange，yrange，Nx,Ny为胞划分信息
%cell=[xmin,xmax,ymin,ymax]，为该胞的范围
%Gama为需要细化的胞的标号，Nn为细化程度

label_old=labelnew2labelold(label_new,Gama,Nn);%新编号所属的胞的老标号
if Gama(label_old)==0%非细化胞
    cell_new=label2cell(label_old,xrange,yrange,Nx,Ny);
else %细化胞
    sort=sortold(label_old,Gama);%该细化胞在重新标号时的顺序
    label_local=label_new-(sort-1)*Nn*Nn;%在细化后胞中的局部标号
    cell_old=label2cell(label_old,xrange,yrange,Nx,Ny);%细化前对应胞的范围
    cell_new=label2cell(label_local,cell_old(1:2),cell_old(3:4),Nn,Nn);
end

end


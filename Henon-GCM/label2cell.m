function cell = label2cell(label,xrange,yrange,Nx,Ny)
%输入一个标号，与胞划分的信息，返回该标号代表的胞的范围
%label为输入的标号，不能输入陷胞标号
%xrange，yrange，Nx,Ny为胞划分信息
%cell=[xmin,xmax,ymin,ymax]，为该胞的范围

i=floor(label/Nx);
j=mod(label,Nx);

dx=(xrange(2)-xrange(1))/Nx;
dy=(yrange(2)-yrange(1))/Ny;

if j==0
    cell=[xrange(2)-dx,xrange(2),yrange(1)+(i-1)*dy,yrange(1)+i*dy];
else
    cell=[xrange(1)+(j-1)*dx,xrange(1)+j*dx,yrange(1)+i*dy,yrange(1)+(i+1)*dy];
end

%说明下排序号的规则：从坐标系左下角一行一行由左向右由下向上排列

end


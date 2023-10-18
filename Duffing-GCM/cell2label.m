function label = cell2label(point,xrange,yrange,Nx,Ny)
%输入一点的位置，与胞划分的信息，返回该点所属的胞编号
%point为输入点的信息
%xrange，yrange，Nx,Ny为胞划分信息
%label为该点所属胞的标号,最后一个标示陷胞

dx=(xrange(2)-xrange(1))/Nx;
dy=(yrange(2)-yrange(1))/Ny;

if point(1)<xrange(1)||point(1)>xrange(2)||point(2)<yrange(1)||point(2)>yrange(2)
    label=Nx*Ny+1;
else
    for i=1:Nx
        if point(1)<xrange(1)+i*dx
            break;
        end
    end
    for j=1:Ny
        if point(2)<yrange(1)+j*dy
            break;
        end
    end
    
    label=Nx*(j-1)+i;
end

end


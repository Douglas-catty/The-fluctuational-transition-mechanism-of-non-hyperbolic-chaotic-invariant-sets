function [exittime] = onestep( linesample,N,ff1,ff2,xlimit,ylimit )
syms x y
exittime=zeros(1,N);
for i=1:N
    xx=linesample(1,i);xxcopy=xx;
    yy=linesample(2,i);yycopy=yy;
    exitstep=0;
    while true
        xx=double(subs(ff1,[x,y],[xxcopy,yycopy]));
        yy=double(subs(ff2,[x,y],[xxcopy,yycopy]));
        xxcopy=xx;
        yycopy=yy;
        exitstep=exitstep+1;
        if xx<xlimit(1,1) | xx>xlimit(1,2) | yy<ylimit(1,1) | yy>ylimit(1,2)
            exittime(1,i)=exitstep;
            break
        end
        %%%挖去包含不变集的区域
        if (xx-1.0208)^2+(yy-0.2972)^2<=(0.01)^2 | (xx-0.2972)^2+(yy-1.0208)^2<=(0.01)^2 | (xx-0.7019)^2+(yy-0.7019)^2<=(0.02)^2 | xx<=-2.2 | xx>=2 | yy<=-2.5 | yy>=6
            exittime(1,i)=exitstep;
            break
        end
        
        %%%
    end
end


end


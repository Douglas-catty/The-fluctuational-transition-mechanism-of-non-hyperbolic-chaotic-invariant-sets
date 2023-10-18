function B = mapnew( z,i,newcenter,h2min,samplenum,numimprove,xyrange2 )
%把陷胞放在末位
judge=0;%指标为0表示像不在xyrange2中，在其中时标记为像胞编号
if z==numimprove
    B=numimprove;
else
    %x1=newcenter(1,z)+0.8*sin(2*pi*i/samplenum)*h2min/2;%圆周半径略小于长宽最小值的一半
    %y1=newcenter(2,z)+0.8*cos(2*pi*i/samplenum)*h2min/2;
    x1=newcenter(1,z)+sin(2*pi*i/samplenum)*h2min/2;
    y1=newcenter(2,z)+cos(2*pi*i/samplenum)*h2min/2;
    X=1.4-x1*x1+0.3*y1;
    Y=x1;

   %寻找单个样本点的像（X，Y）在xyrange2中对应的编号
   
   for k=1:size(xyrange2,2)
       if X>=xyrange2(1,k) & X<=xyrange2(2,k) & Y>=xyrange2(3,k) & Y<=xyrange2(4,k)
           judge=k;
           break
       end
   end
end
   if judge>0
         B=judge;
   else B=numimprove;
   end
end


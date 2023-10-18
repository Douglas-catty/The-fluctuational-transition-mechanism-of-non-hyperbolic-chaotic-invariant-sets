function B=mapnewy(z,i,xyrange2,newcenter,h12,h22,samplenum,numimprove)
%把陷胞放在末位
if z==numimprove
    B=numimprove;
else
    %x1=xyrange2(1,z)+(i-1)*h12/(samplenum-1);
    %y1=newcenter(2,z);
    x1=newcenter(1,z);
    y1=xyrange2(3,z)+(i-1)*h22/(samplenum-1);
    X=1.4-x1*x1+0.3*y1;
    Y=x1;
    
     %寻找单个样本点的像（X，Y）在xyrange2中对应的编号
     judge=0;%指标为0表示像不在xyrange2中，在其中时标记为像胞编号
     for i=1:size(xyrange2,2)
      if X>=xyrange2(1,z) & X<=xyrange2(2,z) & Y>=xyrange2(3,z) & Y<=xyrange2(4,z)
          judge=i;
          break
      end
     end
     
     if judge>0
         B=judge;
     else B=numimprove;
     end
    
    
    
end


end


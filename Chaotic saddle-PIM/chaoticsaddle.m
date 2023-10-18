syms x y
a=1.405;b=-0.3;
%正向Henon映射
ff1=a-x^2+b*y;
ff2=x;
%逆向Henon映射
fb1=y;
fb2=(x+y^2-a)/b;
%（结合胞映射结果）选定合适的restraining region R（R中挖去吸引子及其小邻域）
xlimit=[-2.3,2.2];ylimit=[-2.5,3];
%计算最初选定的PIM三元组
%在这里根据例子选为直线:x=1;y=[-3,3];
xrange=[-2.3,2.2];
yrange=[2,2];
N=50;%每次细化三元组的取样点个数
xrangenew=xrange;
yrangenew=yrange;
chaoticsaddlepoint=[];%记录混沌鞍点的坐标，2行，每列代表一个数值混沌鞍点的坐标
segmenttrajectory=[];%记录迭代直至符合精度的线段短点坐标，4行，每列代表一个线段，12行为起始端的横纵坐标，34行为末端的横纵坐标
%while true
for i=1:1000
    i
linesamplex=linspace(xrangenew(1,1),xrangenew(1,2),N);
linesampley=linspace(yrangenew(1,1),yrangenew(1,2),N);
linesample=[linesamplex;linesampley];%每列代表一个取样点
%计算某一步一组细化样本离出区域R的时间
[exittime] = onestep( linesample,N,ff1,ff2,xlimit,ylimit );
maxexittimenum=find(exittime==max(exittime));
if size(maxexittimenum,2)>1
    %disp('please enlarge N');
    %break
    N=N+20;
else
xrangenew=[linesample(1,maxexittimenum-1),linesample(1,maxexittimenum+1)];
yrangenew=[linesample(2,maxexittimenum-1),linesample(2,maxexittimenum+1)];
 if sqrt((xrangenew(1,2)-xrangenew(1,1))^2+(yrangenew(1,2)-yrangenew(1,1))^2)<=(0.1)^4
     chaoticsaddlepoint=[chaoticsaddlepoint,[(xrangenew(1,1)+xrangenew(1,2))/2;(yrangenew(1,1)+yrangenew(1,2))/2]];
     segmenttrajectory=[segmenttrajectory,[xrangenew(1,1);yrangenew(1,1);xrangenew(1,2);yrangenew(1,2)]];
    break 
 end
end
end

%把得到的线段向前迭代，始终保持误差在（0.1）^8内
N2=0;%重新用来细分区间至每个三元组长度小于（0.1）^8
startpoint=segmenttrajectory(1:2,1);startpointcopy=startpoint;
endpoint=segmenttrajectory(3:4,1);endpointcopy=endpoint;
for i=1:999
    i
    startpoint(1,1)=double(subs(ff1,[x,y],[startpointcopy(1,1),startpointcopy(2,1)]));
    startpoint(2,1)=double(subs(ff2,[x,y],[startpointcopy(1,1),startpointcopy(2,1)]));
    startpointcopy=startpoint;
    endpoint(1,1)=double(subs(ff1,[x,y],[endpointcopy(1,1),endpointcopy(2,1)]));
    endpoint(2,1)=double(subs(ff2,[x,y],[endpointcopy(1,1),endpointcopy(2,1)]));
    endpointcopy=endpoint;
    linelength=sqrt((startpoint(1,1)-endpoint(1,1))^2+(startpoint(2,1)-endpoint(2,1))^2);
    if linelength<=(0.1)^4
        segmenttrajectory=[segmenttrajectory,[startpoint;endpoint]];
        chaoticsaddlepoint=[chaoticsaddlepoint,[(startpoint(1,1)+endpoint(1,1))/2;(startpoint(2,1)+endpoint(2,1))/2]];
    else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      N2=ceil(linelength*(10)^4)+100;
      linesamplex=linspace(startpoint(1,1),endpoint(1,1),N2);
      linesampley=linspace(startpoint(2,1),endpoint(2,1),N2);
      linesample=[linesamplex;linesampley];%每列代表一个取样点
      [exittime] = onestep( linesample,N2,ff1,ff2,xlimit,ylimit );
      maxexittimenum=find(exittime==max(exittime));
      
      if maxexittimenum(1,1)==1
      leftnum=1;
      else
      leftnum=maxexittimenum(1,1)-1;
      end
      
      if maxexittimenum(1,size(maxexittimenum,2))==N2
      rightnum=N2;
      else
      rightnum=maxexittimenum(1,size(maxexittimenum,2))+1;
      end
      
      chaoticsaddlepoint=[chaoticsaddlepoint,[(linesample(1,leftnum)+linesample(1,leftnum))/2;(linesample(2,leftnum)+linesample(2,leftnum))/2]];
      segmenttrajectory=[segmenttrajectory,[linesample(:,leftnum);linesample(:,rightnum)]];
      startpoint=linesample(:,leftnum);
      startpointcopy=startpoint;
      endpoint=linesample(:,rightnum);
      endpointcopy=endpoint;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    end
end
plot(chaoticsaddlepoint(1,:),chaoticsaddlepoint(2,:),'.','MarkerSize',3)
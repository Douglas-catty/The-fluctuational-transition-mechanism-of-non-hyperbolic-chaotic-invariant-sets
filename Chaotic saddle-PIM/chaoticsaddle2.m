% chaotic saddle
% load saddle point
syms x y
a=1.405;b=-0.3;
%’˝œÚHenon”≥…‰
ff1=a-x^2+b*y;
ff2=x;
interatenumber=3;
chaoticsaddletrajectory=saddlepoint;
set(0,'defaultfigurecolor','w');
axis([xmin,xmax,ymin,ymax]);
for i=1:size(saddlepoint,2)
    initialpoint=saddlepoint(:,i);
    initialpointcopy=initialpoint;
    for j=1:interatenumber
        initialpoint(1,1)=double(subs(ff1,[x,y],[initialpointcopy(1,1),initialpointcopy(2,1)]));
        initialpoint(2,1)=double(subs(ff2,[x,y],[initialpointcopy(1,1),initialpointcopy(2,1)]));
        initialpointcopy=initialpoint;
        chaoticsaddletrajectory=[chaoticsaddletrajectory,initialpoint];
    end
end
plot(chaoticsaddletrajectory(1,:),chaoticsaddletrajectory(2,:),'.','MarkerSize',3);
set(0,'defaultfigurecolor','w');
axis([xmin,xmax,ymin,ymax]);
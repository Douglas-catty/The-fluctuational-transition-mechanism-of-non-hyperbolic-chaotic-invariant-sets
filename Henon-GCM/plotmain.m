%load
plot(stablemanifold(1,:),stablemanifold(2,:),'.b','MarkerSize',0.05);
hold on 
plot(unstablemanifold(1,:),unstablemanifold(2,:),'.r','MarkerSize',0.05);
hold on 
plot(saddlepoint(1,:),saddlepoint(2,:),'ok','MarkerSize',1,'MarkerFaceColor','k');
hold on
plot(attractor(1,:),attractor(2,:),'^g','MarkerSize',6,'MarkerFaceColor','g');
hold on
%°×É«±³¾°
set(0,'defaultfigurecolor','w');
period4saddle=[-1.677,1.734,0.217,-1.277;1.734,0.2487,-1.277,-1.477];
plot(period4saddle(1,:),period4saddle(2,:),'^y','MarkerSize',6,'MarkerFaceColor','y');
hold on

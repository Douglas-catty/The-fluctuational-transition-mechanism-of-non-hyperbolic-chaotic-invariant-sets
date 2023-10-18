
clear; clc;
% 主要参数
xmin=-1.8;
xmax=1.8;
ymin=-1.2;
ymax=1.2;
%%Duffing参数
%对应了：x'=y;y'=-2*gamma*y-x+x^3+A*cos(omiga*t);
A=0.07;%周期激励幅值

omiga=1.7;%周期激励频率

gamma=0.01;%耗散系数

%%%%
nn=600;
T=2*pi/omiga;
h=T/nn;%rk4积分步长
%%%%
xrange=[xmin,xmax];
yrange=[ymin,ymax];
zx=300;zy=300;
Nx=zx;Ny=zy;
Nc=zx*zy;          % 胞的个数
h1=(xmax-xmin)/zx;
h2=(ymax-ymin)/zy;
u=4;
czx=u;czy=u;
Ncc=czx*czy;       % 每个胞内取样点个数
I=zeros(1,Nc+1);   % 像胞个数
C=int32(zeros(Nc+1,Ncc)); % 第i个像胞，行数表示对应所有正规胞编号，列表示胞中选取样本点的编号
P=sparse(Nc+1,Ncc); % 转移概率/sparse全0稀疏矩阵，节省内存
Pmatrix=sparse(Nc+1,Nc+1);%完整的转移概率矩阵，为后面求原像信息准备
Im=zeros(1,Ncc);   % 所有取样点的像胞
Ns=u;
sample=zeros(Ns*Ns,2);%存放每个胞的样本点
labels=zeros(Ns*Ns,1);%存放每个胞像胞的标号
% 一步转移概率矩阵P
 for z=1:Nc+1
   [z,Nc+1]
     for i=1:Ncc
         %B=map(z,i,czx,czy,zx,zy,u,Nc,h1,h2,xmin,xmax,ymin,ymax,AA,BB);Im(i)=B;%B为第z个胞中第i个样本点在固定时长映射下的像，Im暂态储存第z个胞中所有取样点的像
         B=mapDuffing(z,i,czx,czy,zx,zy,u,Nc,h1,h2,xmin,xmax,ymin,ymax,A,omiga,gamma,h,nn);Im(i)=B;
     end
     
     
     I(z)=numel(unique(Im));%第z个胞取样点的所有像胞个数
     
     if z == 1
     fimage(1,z)=0;
     else
         fimage(1,z)=fimage(1,z-1)+I(z);
     end
     
     C(z,1:I(z))=unique(Im);%C;(Nc+1)xNcc,每行中行数z代表胞序号，列数代表对应胞中取样点序号
     for i=1:I(z)
         P(z,i)=sum(Im==C(z,i))/Ncc;
     end
     for i=1:I(z)
     Pmatrix(z,C(z,i))=P(z,i);
     end
 end
 %邻接矩阵NCM
 NCM=sparse(zx*zy+1,zx*zy+1);%邻接矩阵初始化，陷胞放在最后一位标号/sparse稀疏矩阵节省内存
 NCM(zx*zy+1,zx*zy+1)=1;%建立陷胞关系
 for i=1:size(C,1)
     for j=1:size(find(C(i,:)>0),2)
         
         NCM(i,C(i,j))=1;
         
     end
 end
 save('A=0.07omiga=1.7gamma=0.07.mat')
  %原像信息
 %preC=zeros(Nc+1,500);
 %preP=zeros(Nc+1,500);
 %for i=1:Nc+1
 %    K=find(Pmatrix(:,i)~=0)';
 %    preC(i,1:size(K,2))=K;
 %    for j=1:size(K,2)
 %    preP(i,j)=Pmatrix(K(1,j),i);
 %    end
 %end
 
 % 寻找强连通分支

C=int32(C);
I=int32(I);
Nc=int32(Nc);
DFN=int32(zeros(Nc+1,1));%用来存放每个顶点被访问的时间
LOW=int32(zeros(Nc+1,1));%用来存放每个顶点所在的强连通分支的根节点的时间
Ncom=int32(0);%强连通子图的个数
stccom=int32(zeros(Nc+1,1));%每个胞所属的强连通子图的编号
stack=int32(zeros(Nc+1,1));%堆栈
isstack=int32(zeros(Nc+1,1));%判断是否在栈中
num=int32(1);%顶点访问顺序
top=int32(0);%栈中元素个数
for i=1:Nc
    if DFN(i,1)==0
        [DFN, LOW, Ncom ,stccom, stack, isstack, num, top]=tarjan(DFN, LOW, Ncom ,stccom, stack, isstack, num, top,i,I,C);%tarjin算法求所有强连通子图
    end
end
%Ncom强联通子图个数=周期解+瞬态胞个数；stccom星形表示每个胞所属的强连通子图的编号
Bcnt=max(stccom);
%强连通子图分类为第一类、第二类、第三类顶点
%第一类为闭的强联通子图表征系统的稳定解；第二类为开的强联通子图表示系统的不稳定解；第三类为瞬态顶点
CSC=classifySC(NCM,stccom,Bcnt);%三类顶点分别用正数，负数，零标记

%将第三类顶点分类
S=stop2SC(NCM,CSC);%驻足
R=SC2routing(NCM,CSC);%路由

n=max(CSC);%第一类强连通子图个数，n=1表示编号为最后一位的陷胞
m=-min(CSC);%第二类强连通子图中鞍点的个数
%出图

%出流型图
h1=figure;
% set(h1,'visible','off')%显示图片太耗内存，保存后再看
set(0,'defaultfigurecolor','w')
hold on 

%稳定流型
stablemanifold=[];
stablemanifoldnumber=[];
for i=1:m
    pos1=find(S(n+i,:)==-i-0.1);
    stablemanifoldnumber=[stablemanifoldnumber,pos1];
    for j=1:length(pos1)
        xy=label2cell(pos1(j),xrange,yrange,Nx,Ny);
        xcen=(xy(1)+xy(2))/2;
        ycen=(xy(3)+xy(4))/2;
        stablemanifold=[stablemanifold,[xcen;ycen]];
        
    end
    plot(stablemanifold(1,:),stablemanifold(2,:),'*b','MarkerSize',0.5);
end
%不稳定流型
unstablemanifold=[];
unstablemanifoldnumber=[];
for i=1:m
    pos2=find(R(i,:)==-i-0.5);
    unstablemanifoldnumber=[unstablemanifoldnumber,pos2];
    for j=1:length(pos2)
        xy=label2cell(pos2(j),xrange,yrange,Nx,Ny);
        xcen=(xy(1)+xy(2))/2;
        ycen=(xy(3)+xy(4))/2;
        unstablemanifold=[unstablemanifold,[xcen;ycen]];
        
    end
    plot(unstablemanifold(1,:),unstablemanifold(2,:),'*r','MarkerSize',1);
end
%plot([1,-1],[0,0],'go','MarkerFaceColor','g');plot([0],[0],'ko','MarkerFaceColor','k');
%鞍
saddlepoint=[];
saddlepointnumber=[];
for i=1:m
    pos3=find(CSC==-i);
    saddlepointnumber=[saddlepointnumber,pos3];
    for j=1:length(pos3)
        xy=label2cell(pos3(j),xrange,yrange,Nx,Ny);
        xcen=(xy(1)+xy(2))/2;
        ycen=(xy(3)+xy(4))/2;
        saddlepoint=[saddlepoint,[xcen;ycen]];
        
    end
    plot(saddlepoint(1,:),saddlepoint(2,:),'^y','MarkerSize',10,'MarkerFaceColor','y');
end
%吸引子
attractor=[];
attractornumber=[];
for i=1:n
    pos4=find(CSC==i);
    %i=1情况对应驻胞
    if i~=1
    attractornumber=[attractornumber,pos4];
    end
    for j=1:length(pos4)
        if pos4(j)==Nx*Ny+1%陷胞
            continue;
        end
        xy=label2cell(pos4(j),xrange,yrange,Nx,Ny);
        xcen=(xy(1)+xy(2))/2;
        ycen=(xy(3)+xy(4))/2;
        attractor=[attractor,[xcen;ycen]];
        
    end
    if i~=1
    plot(attractor(1,:),attractor(2,:),'*g','MarkerSize',3);
    end
end
xlim([xmin xmax]);
ylim([ymin ymax]);
hold off

%%save('AA=1.1BB=-0.3.mat','zx','zy','attractor','attractornumber','saddlepoint','saddlepointnumber','stablemanifold','stablemanifoldnumber','unstablemanifold','unstablemanifoldnumber','attractordomain','attractordomainnumber','AA','BB','xmin','xmax','ymin','ymax')%保存全部数据供actionplot选定初始点

 %出吸引子吸引域图
 h2=figure;
 hold on;

 %吸引域
 attractordomain=[];
 attractordomainnumber=[];
 for i=1:n
     if find(CSC==i)==Nx*Ny+1%陷胞
         continue;
     end
     pos6=find(S(i,:)==i+0.1);
     attractordomainnumber=[attractordomainnumber,pos6];
     for j=1:length(pos6)
         xy=label2cell(pos6(j),xrange,yrange,Nx,Ny);
         xcen=(xy(1)+xy(2))/2;
         ycen=(xy(3)+xy(4))/2;
         %plot(xcen,ycen,'*','MarkerSize',6);
         attractordomain=[attractordomain,[xcen;ycen]];
     end
     plot(attractordomain(1,:),attractordomain(2,:),'*','MarkerSize',0.5);
 end
 
  %吸引子
 for i=1:n
     pos5=find(CSC==i);
     for j=1:length(pos5)
         if pos5(j)==Nx*Ny+1%陷胞
             continue;
         end
         xy=label2cell(pos5(j),xrange,yrange,Nx,Ny);
         xcen=(xy(1)+xy(2))/2;
         ycen=(xy(3)+xy(4))/2;
         plot(xcen,ycen,'^g','MarkerSize',6);
     end
 end
 hold off

 

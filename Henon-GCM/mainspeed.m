clear; clc;
% ��Ҫ����
xmin=-2.5;
xmax=2.5;
ymin=-2.5;
ymax=2.5;
xrange=[xmin,xmax];
yrange=[ymin,ymax];
zx=1000;zy=1000;
Nx=zx;Ny=zy;
Nc=zx*zy;          % ���ĸ���
u=4;
h1=(xmax-xmin)/zx;
h2=(ymax-ymin)/zy;
czx=4;czy=4;
Ncc=czx*czy;       % ÿ������ȡ�������
I=zeros(1,Nc+1);   % �������
C=int32(zeros(Nc+1,Ncc)); % ��i�������������ʾ��Ӧ�����������ţ��б�ʾ����ѡȡ������ı��
P=sparse(Nc+1,Ncc); % ת�Ƹ���/sparseȫ0ϡ����󣬽�ʡ�ڴ�
Pmatrix=sparse(Nc+1,Nc+1);%������ת�Ƹ��ʾ���Ϊ������ԭ����Ϣ׼��
Im=zeros(1,Ncc);   % ����ȡ��������

%CoreNum=6; %�趨����CPU��������,���ò��м���
%if isempty(gcp('nocreate'))
%    parpool(CoreNum);
%end


% һ��ת�Ƹ��ʾ���P
for z=1:Nc+1
   z
     for i=1:Ncc
         B=map(z,i,czx,czy,zx,zy,u,Nc,h1,h2,xmin,xmax,ymin,ymax);Im(i)=B;%BΪ��z�����е�i���������ڹ̶�ʱ��ӳ���µ���Im��̬�����z����������ȡ�������
         
     end
     
     
     I(z)=numel(unique(Im));%��z����ȡ����������������
     
     if z == 1
     fimage(1,z)=0;
     else
         fimage(1,z)=fimage(1,z-1)+I(z);
     end
     
     C(z,1:I(z))=unique(Im);%C;(Nc+1)xNcc,ÿ��������z��������ţ�����������Ӧ����ȡ�������
     for i=1:I(z)
         P(z,i)=sum(Im==C(z,i))/Ncc;
     end
     for i=1:I(z)
     Pmatrix(z,C(z,i))=P(z,i);
     end
 end
 %�ڽӾ���NCM
 NCM=sparse(zx*zy+1,zx*zy+1);%�ڽӾ����ʼ�����ݰ��������һλ���/sparseϡ������ʡ�ڴ�
 NCM(zx*zy+1,zx*zy+1)=1;%�����ݰ���ϵ
 for i=1:size(C,1)
     for j=1:size(find(C(i,:)>0),2)
         
         NCM(i,C(i,j))=1;
         
     end
 end
  %ԭ����Ϣ
 %preC=zeros(Nc+1,500);
 %preP=zeros(Nc+1,500);
 %for i=1:Nc+1
 %    K=find(Pmatrix(:,i)~=0)';
 %    preC(i,1:size(K,2))=K;
 %    for j=1:size(K,2)
 %    preP(i,j)=Pmatrix(K(1,j),i);
 %    end
 %end
 
 % Ѱ��ǿ��ͨ��֧

C=int32(C);
I=int32(I);
Nc=int32(Nc);
DFN=int32(zeros(Nc+1,1));%�������ÿ�����㱻���ʵ�ʱ��
LOW=int32(zeros(Nc+1,1));%�������ÿ���������ڵ�ǿ��ͨ��֧�ĸ��ڵ��ʱ��
Ncom=int32(0);%ǿ��ͨ��ͼ�ĸ���
stccom=int32(zeros(Nc+1,1));%ÿ����������ǿ��ͨ��ͼ�ı��
stack=int32(zeros(Nc+1,1));%��ջ
isstack=int32(zeros(Nc+1,1));%�ж��Ƿ���ջ��
num=int32(1);%�������˳��
top=int32(0);%ջ��Ԫ�ظ���
for i=1:Nc
    if DFN(i,1)==0
        [DFN, LOW, Ncom ,stccom, stack, isstack, num, top]=tarjan(DFN, LOW, Ncom ,stccom, stack, isstack, num, top,i,I,C);%tarjin�㷨������ǿ��ͨ��ͼ
    end
end
%Ncomǿ��ͨ��ͼ����=���ڽ�+˲̬��������stccom���α�ʾÿ����������ǿ��ͨ��ͼ�ı��
Bcnt=max(stccom);
%ǿ��ͨ��ͼ����Ϊ��һ�ࡢ�ڶ��ࡢ�����ඥ��
%��һ��Ϊ�յ�ǿ��ͨ��ͼ����ϵͳ���ȶ��⣻�ڶ���Ϊ����ǿ��ͨ��ͼ��ʾϵͳ�Ĳ��ȶ��⣻������Ϊ˲̬����
disp('strongconnect has been searched');
CSC=classifySC(NCM,stccom,Bcnt);%���ඥ��ֱ�������������������
disp('three kinds of strongconnect has been identified');
%�������ඥ�����
S=stop2SC(NCM,CSC);%פ��
R=SC2routing(NCM,CSC);%·��

n=max(CSC);%��һ��ǿ��ͨ��ͼ����
m=-min(CSC);%�ڶ���ǿ��ͨ��ͼ�а���ĸ���
%��ͼ

%������ͼ
h1=figure;
% set(h1,'visible','off')%��ʾͼƬ̫���ڴ棬������ٿ�
hold on 

%�ȶ�����
for i=1:m
    pos=find(S(n+i,:)==-i-0.1);
    for j=1:length(pos)
        xy=label2cell(pos(j),xrange,yrange,Nx,Ny);
        xcen=(xy(1)+xy(2))/2;
        ycen=(xy(3)+xy(4))/2;
        plot(xcen,ycen,'*b','MarkerSize',1);
    end
end
%���ȶ�����
for i=1:m
    pos=find(R(i,:)==-i-0.5);
    for j=1:length(pos)
        xy=label2cell(pos(j),xrange,yrange,Nx,Ny);
        xcen=(xy(1)+xy(2))/2;
        ycen=(xy(3)+xy(4))/2;
        plot(xcen,ycen,'*r','MarkerSize',1);
    end
end
%��
for i=1:m
    pos=find(CSC==-i);
    for j=1:length(pos)
        xy=label2cell(pos(j),xrange,yrange,Nx,Ny);
        xcen=(xy(1)+xy(2))/2;
        ycen=(xy(3)+xy(4))/2;
        plot(xcen,ycen,'.k','MarkerSize',20);
    end
end
%������
for i=1:n
    pos=find(CSC==i);
    for j=1:length(pos)
        if pos(j)==Nx*Ny+1%�ݰ�
            continue;
        end
        xy=label2cell(pos(j),xrange,yrange,Nx,Ny);
        xcen=(xy(1)+xy(2))/2;
        ycen=(xy(3)+xy(4))/2;
        plot(xcen,ycen,'*g','MarkerSize',1);
    end
end
hold off
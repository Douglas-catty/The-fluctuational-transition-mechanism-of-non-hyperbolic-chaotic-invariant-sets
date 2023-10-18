close,clc,clear all
global DFN LOW Ncom stccom stack isstack num top
% load('I')%原胞的相数目
% load('C')%原胞对应的相胞编号
load dataNCM.mat
I=sum(NCM,2);
C=zeros(size(NCM,1),size(NCM,2));
for i=1:size(NCM,1)
    temp=find(NCM(i,:)==1);
    le=length(temp);
    C(i,1:le)=temp;
end
N=size(I,1);
DFN=zeros(N,1);
LOW=zeros(N,1);
stack=zeros(N,1);
isstack=zeros(N,1);
top=0;
num=1;
Ncom=0;
stccom=zeros(N,1);
set(0,'RecursionLimit',2000);
while 1
    label=find(DFN==0,1);
    if isempty(label)
        break;
    end
    tarjin_cz(label,I,C)
end
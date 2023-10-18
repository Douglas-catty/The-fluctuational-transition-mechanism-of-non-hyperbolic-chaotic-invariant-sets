function AA=mapDuffing(B,n,czx,czy,zx,zy,u,Nc,h1,h2,xmin,xmax,ymin,ymax,A,omiga,gamma,h,nn)
%h为rk4积分步长
if B==Nc+1
    AA=Nc+1;
    %陷胞放最后一位
else x1=h1*mod(B-1,zx)+xmin+(h1/czx)*(mod(n-1,czx)+0.5);%mod(A,B),求A除B的余数，floor向下取整数，十字取胞内样本点
    y1=h2*(floor(B/zx)-(mod(B,zx)==0))+ymin+(h2/czy)*(floor(n/czx)-(mod(n,czx)==0)+0.5);
    %X=[x1 y1]';
    %f=@(t,x)[x(2);-25*x(1)^3-0.173*x(2)-2.62*x(1)+0.456*u*(1-cos(2*t))*x(1)+0.92*u*(1-cos(2*t))];
    %[~,M]=ode45(f,[0,pi],X);
    %X=M(length(M(:,1)),:)';
    
     %   Heon map
     %   X=AA-x1*x1+BB*y1;
     %   Y=x1;
     X=x1;
     Y=y1;
     Z=0;
     for i=1:nn
         %[dx,dy,dz]=rk4(X,Y,Z,h,A,omiga,gamma);
         %  X=X+dx;
         %  Y=Y+dy;
         %  Z=Z+dz;
         
         X=X+Y*h;
         Y=Y+(-2*gamma*Y+X-X^3+A*cos(omiga*i*h))*h;
         %initial(:,2)=initial(:,2)+(-2*zeta*initial(:,2)-sin(initial(:,1))+h*cos(wf*i*dt))
     end
    
    %if (X(1)>=xmin)&&(X(1)<xmax)&&(X(2)>=ymin)&&(X(2)<ymax)
    if (X>=xmin)&&(X<xmax)&&(Y>=ymin)&&(Y<ymax)
        AA=zx*floor((Y-ymin)/h2)+floor((X-xmin)/h1+1);%正常阅读顺序下的胞序号
    else AA=Nc+1;
    end
end


function [dx,dy,dz] = rk4(x,y,z,h,A,omiga,gamma)

%h积分步长

K1=f1(x,y,z,A,omiga,gamma);
K2=f1(x+h*K1/2,y+h*K1/2,z+h*K1/2,A,omiga,gamma);
K3=f1(x+h*K2/2,y+h*K2/2,z+h*K2/2,A,omiga,gamma);
K4=f1(x+h*K3,y+h*K3,z+h*K3,A,omiga,gamma);
L1=f2(x,y,z,A,omiga,gamma);
L2=f2(x+h*L1/2,y+h*L1/2,z+h*L1/2,A,omiga,gamma);
L3=f2(x+h*L2/2,y+h*L2/2,z+h*L2/2,A,omiga,gamma);
L4=f2(x+h*L3,y+h*L3,z+h*L3,A,omiga,gamma);
M1=f3(x,y,z,A,omiga,gamma);
M2=f3(x+h*M1/2,y+h*M1/2,z+h*M1/2,A,omiga,gamma);
M3=f3(x+h*M2/2,y+h*M2/2,z+h*M2/2,A,omiga,gamma);
M4=f3(x+h*M3,y+h*M3,z+h*M3,A,omiga,gamma);

dx=(K1+2*K2+2*K3+K4)*h/6;
dy=(L1+2*L2+2*L3+L4)*h/6;
dz=(M1+2*M2+2*M3+M4)*h/6;

end


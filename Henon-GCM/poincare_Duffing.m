function y=poincare_Duffing(dt,zeta,w0,h,wf,D,initial,N)
%模拟I. A. Khovanov 08年论文中的Duffing振子系统
%delta为计算步长，zeta为阻尼，w0为刚度参数，h为简谐激励幅值，wf为间歇激励频率，D为白噪声强度参数，N为样本数
T=2*pi/wf;%周期
n=T/dt;%一周期迭代数(最好保证为整数）

for i=1:n
    winc=sqrt(dt)*randn(N,1);
    initial(:,1)=initial(:,1)+initial(:,2)*dt;
    initial(:,2)=initial(:,2)+(-2*zeta*initial(:,2)-w0^2*initial(:,1)-initial(:,1).^2-initial(:,1).^3+h*sin(wf*i*dt))*dt+sqrt(D)*winc;
end
y=initial;

end

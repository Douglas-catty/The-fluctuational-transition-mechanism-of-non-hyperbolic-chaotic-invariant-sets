function y = map2( initial )

initial(:,1)=1.4-initial(:,1)*initial(:,1)+0.3*initial(:,2);
initial(:,2)=initial(:,1);
y=initial;

end
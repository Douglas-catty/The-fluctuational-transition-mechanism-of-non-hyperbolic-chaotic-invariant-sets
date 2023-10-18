function sort= sortold(label_old,Gama)
%SORTOLD 老标号的重新标号顺序
%   label_old 老标号
%   Gama需要细化的标号
%   说明顺序：先排需要细化的胞，再排不需要细化的胞

n=sum(Gama);%需要细化的胞的总数

if Gama(label_old)==0%非细化胞
    pos=Gama==0;
    sort=n+sum(pos(1:label_old));
else %细化胞
    sort=sum(Gama(1:label_old));
end

end


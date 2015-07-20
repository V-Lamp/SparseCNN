n=4;
clc;
X=ones(n)*10
w=ones(n)*6
v=w
for i =1:n
    v(i,:) = v(i,:)/(max(v(i,:)*n))
    w(i,:) = w(i,:)/sum(w(i,:))
end
w
v

Y=ones(n)
for i=1:2
    disp( '///////////////////////////////////')
    R=v'*Y
    E=X./R
    dY=w*E
    Y=Y.*dY
end
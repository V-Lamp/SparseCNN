n_in=6;n_out=4;m=1;
clc;
rng(123)
X=rand(n_in,m)*100
w=rand(n_out,n_in)*100

pinv(w)
dY=ones(n_out,1)
pinv(w)*dY
w\dY
mldivide(w,dY)


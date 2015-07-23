n_in=6;n_out=6;m=1
clc;
rng(123)
X=rand(n_in,m)*100
w=rand(n_out,n_in)*100;
Y = simpleDIM1d(w,X,50)


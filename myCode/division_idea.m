X=rand(32);
R=X+(0.01*(rand(32)-0.5));
R=R-0.5;
E=X./R;

hist(E(:),100)

tr= @(x) 
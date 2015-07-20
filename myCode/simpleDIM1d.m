
function Y= simpleDIM1d(w,X,iterations)
    if nargin == 0
        clc;
        clear variables
        n_in=6;n_out=6;m=1;

        rng(123)
        X=ones(n_in,m)*10
        w=(rand(n_out,n_in)-0)*100;       
        iterations=3;
    end
    n_out=size(w,1);
    m=size(X,2);
    vn=w;
    for i =1:n_out
        vn(i,:) = vn(i,:)/(max(vn(i,:))*n_out);
        wn(i,:) = w(i,:)./sum(w(i,:));
    end
    wn
    vn

    Y=wn*X
    for i=1:iterations
        disp( '///////////////////////////////////')
        i
        R=vn'*Y
        E=f(X,R)
        dY=wn*E
        Y=g(Y,dY)
    end
    disp( '///////////////////////////////////')
    X
    c=wn*X
    divide= @(a,b) pinv(a)*b;
    Yan=divide(vn',X./divide(wn,ones(n_out,1)))
    means=[mean(X), mean(Y), mean(wn*X),mean(Yan)]
end
    
function e=f(x,r)
    c1=min(x(:));
    c2=min(r(:));
    c= min(c1,c2);
    epsilon=0.01;
    e=(x-c+epsilon)./(r-c+epsilon);
    if any(e<0)
        stop
    end
end
function yn=g(y,dy)
    c1=min(y(:));
    c2=min(dy(:));
    c= min(c1,c2);
    epsilon=0.01;
    yn=(y-c+epsilon)./(dy-c+epsilon);
end
    
 
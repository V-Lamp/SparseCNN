function [ h ] = better_subplot(n,m,i )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    
    h = subplot(n,m,i);

    p = get(h, 'pos');
    scale= 0.2;
    p(1) = p(1)-p(3)*scale/2;
    p(2)= p(2)- p(4)*scale/2;
    p(3) = p(3)*(1+scale);
    p(4) = p(4)*(1+scale);
    set(h, 'pos', p);
    
end


function [] = test()
    x= rand(10,1)-0.5;
    y = scaled(x,0.5)
    
end
function y = scaled(x, minval)
    y = x - min(x(:)); %first make positive
    y  = y / mean(y(:))+minval;
end


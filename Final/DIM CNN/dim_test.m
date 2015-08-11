function [er, bad, correct] = dim_test(net, x, y, dim_impl)
%TEST_DIM_CNN Summary of this function goes here
%   Detailed explanation goes here
    net = dim_ff(net, x, dim_impl);
    [~, h] = max(net.o);
    [~, a] = max(y);
    bad = find(h ~= a);
    correct = find(h == a);
    er = numel(bad) / size(y, 2);

end


function [er, bad, correct] = perc_test(net, x, y)
%TEST_DIM_CNN Summary of this function goes here
%   Detailed explanation goes here
    net = perc_ff(net, x);
    [~, h] = max(net.o);
    [~, a] = max(y);
    bad = find(h ~= a);
    correct = find(h == a);
    er = numel(bad) / size(y, 2);

end


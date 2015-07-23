function [er, bad] = cnntest_DIM(net, x, y)
    %  feedforward
    net = cnnff_DIM(net, x);
    [~, h] = max(net.o);
    [~, a] = max(y);
    bad = find(h ~= a);

    er = numel(bad) / size(y, 2);
end

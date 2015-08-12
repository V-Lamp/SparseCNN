function [ net ] = perc_ff(net, X )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    net.fv = [];
    for j = 1 : numel(X)
        sa = size(X{j});
        if numel(sa) == 2
            net.fv = [net.fv; reshape(X{j}, sa(1) * sa(2), 1)];
        else
            net.fv = [net.fv; reshape(X{j}, sa(1) * sa(2), sa(3))];
        end
    end
    %  feedforward into output perceptrons
    net.o = sigm(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2)));

end


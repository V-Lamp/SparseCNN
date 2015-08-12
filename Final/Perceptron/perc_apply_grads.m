function [ net ] = perc_apply_grads( net, opts )
%DIM_APPLY_GRADS Summary of this function goes here
%   Detailed explanation goes here
    net.ffW = net.ffW - opts.alpha * net.dffW;
    net.ffb = net.ffb - opts.alpha * net.dffb;
end


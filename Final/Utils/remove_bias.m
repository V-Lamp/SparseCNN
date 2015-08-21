function [ net ] = remove_bias( net )
%REMOVE_BIAS Summary of this function goes here
%   Detailed explanation goes here
for i = [2,4]
    for j = 1:numel(net.layers{i}.b)        
        net.layers{i}.b{j}=0;
    end
end

end



function net = cnnff(net, x)
    n = numel(net.layers);
    net.layers{1}.a{1} = x;
    inputmaps = 1;

    for l = 2 : n   %  for each layer
        if strcmp(net.layers{l}.type, 'c')
            %  !!below can probably be handled by insane matrix operations
            if  ~isfield(net.layers{l}, 'a')
                net.layers{l}.a={};
            end
            net.layers{l}.a = DIM_MaskSplitting(...
                net.layers{l - 1}.a, ...
                net.layers{l}.k.', ...
                'valid',net.layers{l}.a);
            for j = 1 : net.layers{l}.outputmaps   %  for each output map%                 
                net.layers{l}.a{j} = sigm( net.layers{l}.a{j} + net.layers{l}.b{j});
            end
            %  set number of input maps to this layers number of outputmaps
            inputmaps = net.layers{l}.outputmaps;
        elseif strcmp(net.layers{l}.type, 's')
            %  downsample
            for j = 1 : inputmaps
                
                z = convn(...
                    net.layers{l - 1}.a{j}, ...
                    ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), ...
                    'valid');   %  !! replace with variable
                net.layers{l}.a{j} = z(...
                        1 : net.layers{l}.scale : end, ...
                        1 : net.layers{l}.scale : end, :);
            end
        end
    end

    %  concatenate all end layer feature maps into vector
    net.fv = [];
    for j = 1 : numel(net.layers{n}.a)
        sa = size(net.layers{n}.a{j});
        net.fv = [net.fv; reshape(net.layers{n}.a{j}, sa(1) * sa(2), sa(3))];
    end
    %  feedforward into output perceptrons
    net.o = sigm(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2)));
    
end

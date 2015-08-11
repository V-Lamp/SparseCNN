function [ net ] = fc_train( net, train_x, train_y, opts, ff_impl)
%TRAIN_DIM_CNN Summary of this function goes here
%   Detailed explanation goes here
    
%% training
    m = size(train_x, 3);
    numbatches = m / opts.batchsize;
    if rem(numbatches, 1) ~= 0
        disp(numbatches)
        error('numbatches not integer');        
    end
    
    for i = 1 : opts.numepochs
        net.rL = [];
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        tic;
        kk = randperm(m);
        for batch = 1 : numbatches
            batch_x = train_x(:, :, kk((batch - 1) * opts.batchsize + 1 : batch * opts.batchsize));
            batch_y = train_y(:,    kk((batch - 1) * opts.batchsize + 1 : batch * opts.batchsize));

            net = ff_impl(net, batch_x);
            net = fc_bp(net, batch_y);
            net = fc_apply_grads(net, opts);
            if isempty(net.rL)
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
            disp(['Epoch: ',num2str(i),' batch: ', num2str(batch), '/',num2str(numbatches)])
            
        end
        toc;
    end
end


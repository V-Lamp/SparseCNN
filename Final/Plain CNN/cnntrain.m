function net = cnntrain(net, x, y, opts)
    m = size(x, 3);
    numbatches = m / opts.batchsize;
    if rem(numbatches, 1) ~= 0
        disp(numbatches)
        error('numbatches not integer');        
    end
    net.rL = [];
    figure;
    for i = 1 : opts.numepochs
        net.L_epoch=[];
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        tic;
        kk = randperm(m);
        for l = 1 : numbatches
            batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

            net = cnnff(net, batch_x);
            net = cnnbp(net, batch_y);
            net = cnnapplygrads(net, opts);
%             if isempty(net.rL)
%                 net.rL(1) = net.L;
%             end
%             net.rL(end + 1) = 0.999 * net.rL(end) + 0.001 * net.L;
            
            net.L_epoch = [net.L_epoch, net.L];
        end
        toc;
        net.rL(i) = mean(net.L_epoch);
        
        disp([net.rL(i), net.rL(i)-net.rL(max(1,i-1))]);
        semilogy(net.rL);
        drawnow
        opts.alpha = opts.alpha*0.98;
    end
    
end

clear variables;
close all;
sz= 28;
n_samp = 8;
x=zeros(sz,sz,n_samp);
% x_gen = zeros(sz);
% x_gen(1:sz/2,1:sz) =1;
% x(:,:,1) = x_gen;
% for i = 2:4
%     x(:,:,i) = rot90(x(:,:,i-1));
%     y(:,i) = zeros(4,1);
% end
for i =1:n_samp
    x(:,i*3:end,i)=1;
end


y = eye(n_samp);
%%
cnn = build_cnn(5,[6,12],[sz,sz],n_samp);
opts.alpha = 2;
opts.batchsize = 2;
opts.numepochs = 800;

cnn = cnntrain(cnn, x, y, opts);

figure; plot(cnn.rL);
er = cnntest(cnn, x, y)
for i = 1:4
    cnn = cnnff(cnn, x(:,:,i));
    plot_network(cnn)
    pause(0.5)
end
assert(er<0.12, 'Too big error');

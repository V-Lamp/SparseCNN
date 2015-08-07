function test_cnn_gradients
batch_x = rand(28,28,5);
batch_y = rand(10,5);
% cnn.layers = {
%     struct('type', 'i') %input layer
%     struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
%     struct('type', 's', 'scale', 2) %sub sampling layer
%     struct('type', 'c', 'outputmaps', 2, 'kernelsize', 5) %convolution layer
%     struct('type', 's', 'scale', 2) %subsampling layer
% };
% cnn = cnnsetup(cnn, batch_x, batch_y);
cnn = build_cnn(5,[2,2],[28,28],10);
cnn = cnnff(cnn, batch_x);
cnn = cnnbp(cnn, batch_y);
cnnnumgradcheck(cnn, batch_x, batch_y);
disp('Gradients are correct!')
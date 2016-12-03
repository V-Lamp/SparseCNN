%% CNN
S = load('small_cnn');

impl = @(X)cnn_last_layer(S.cnn, X);
save_outputs(impl,'out_cnn');
%% DIM sep mask splitting
S = load('small_cnn');

dim_impl = @DIM_sep_mask_splitting;

net = dim_setup(S.cnn,[28,28],10);
%net = remove_bias(net);
impl = @(X) dim_last_layer(net, X, dim_impl);
save_outputs(impl,'out_dim_sep_mask_split');

%% DIM pcbc
S = load('small_cnn');

dim_impl = @DIM_MaskSplitting;

net = dim_setup(S.cnn,[28,28],10);
%net = remove_bias(net);
impl = @(X)dim_last_layer(net, X, dim_impl);
save_outputs(impl,'out_dim_mask_split');

% %% DIM scaling
% S = load('small_cnn');
% 
% dim_impl = @DIM_sigmoids;
% 
% net = dim_setup(S.cnn,[28,28],10);
% net = remove_bias(net);
% impl = @(X)dim_last_layer(net, X, dim_impl);
% save_outputs(impl,'out_dim_scaling');
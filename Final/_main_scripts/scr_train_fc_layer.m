

%% CNN
[~, train_y, ~, test_y] = get_mnist_data();
S = load(['saved_data',filesep,'out_cnn']);

res_cnn = perc_train_from_inputs(S.train_out,train_y, S.test_out,test_y)

%% DIM sep mask splitting
[~, train_y, ~, test_y] = get_mnist_data();
S = load(['saved_data',filesep,'out_dim_sep_mask_split']);
% S.train_out= transform_saved(S.train_out);
% S.test_out= transform_saved(S.test_out);
res_sep_mask_split = perc_train_from_inputs(S.train_out,train_y, S.test_out,test_y)

%% DIM mask splitting
[~, train_y, ~, test_y] = get_mnist_data();
S = load(['saved_data',filesep,'out_dim_mask_split']);

res_mask_split = perc_train_from_inputs(S.train_out,train_y, S.test_out,test_y)
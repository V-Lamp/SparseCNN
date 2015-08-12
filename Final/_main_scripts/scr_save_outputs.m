
S = load('saved_data\small_cnn');
dim_impl = @DIM_MaskSplitting;
dim = @(X)cnn_last_layer(S.cnn, X);
save_outputs(dim,'dim_out_mask_split');
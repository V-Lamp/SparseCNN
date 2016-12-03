S = load('small_cnn');
[train_x, train_y, test_x, test_y] = get_mnist_data();
sample = test_x(:,:,1:4);

dim_impls = {@DIM_MaskSplitting, @DIM_sigmoids, @DIM_sep_mask_splitting};
masks = S.cnn.layers{2}.k';

for i =1:numel(dim_impls)
    out_batch{i} = dim_impls{i}({sample},masks,{},30);
    out_ser{i} = {};
    for j = 1:size(sample, 3);
        res = dim_impls{i}({sample(:,:,j)},masks,{},30);
        for k = 1:size(masks,1)
            out_ser{i}{k}(:,:,j) = res{k};
        end        
    end
end
for i =1:numel(dim_impls)
    for j =1:size(masks,1)
        batch = out_batch{i}{j};
        ser = out_ser{i}{j};
        diff =  batch - ser;
        disp(['i =: ', num2str(i)])
        disp(['sum of diff: ', num2str( sum(diff(:)))])
    end
end
%%
[train_x, train_y, test_x, test_y] = get_mnist_data();
for i = 1:60000
    for j = 1:10000
        train = train_x(:,:,i);
        test=test_x(:,:,j);
        res(i,j) = all(train(:) == test(:));
    end
end
sum(res(:))

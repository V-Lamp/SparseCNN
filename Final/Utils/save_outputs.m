function save_outputs(func, filename )
%SAVE_OUTPUTS Summary of this function goes here
%   Detailed explanation goes here
    [train_x, ~, test_x, ~] = get_mnist_data();
    train_out = get_output(func, train_x);
    test_out = get_output(func, test_x);
    
    save (['saved_data',filesep,filename], 'train_out', 'test_out');

end
function out = get_output(func, input)
    z = size(input,3);
    
    out_dummy = func(input(:,:,1));
    
    n_l  =numel(out_dummy);
    out = cell(n_l,1);
    
    for j =1:n_l
        n_maps = numel(out_dummy{j});
        map_size = size(out_dummy{j}{1});
        out{j} = cell(numel(out_dummy{j}));
        for k = 1:n_maps
            out{j}{k} = zeros([map_size, z]);
        end
    end
    
    tic
    for i = 1:z        
        out_single = func(input(:,:,i));        
        for j =1:n_l
            n_maps = numel(out_single{j});
            for k = 1:n_maps
                out{j}{k}(:,:,i) = out_single{j}{k};
            end
        end
        
        if mod(i,100) == 0
            toc
            disp(i)
            tic
        end
    end
    toc
end

function save_outputs(func, filename )
%SAVE_OUTPUTS Summary of this function goes here
%   Detailed explanation goes here
    [train_x, ~, test_x, ~] = get_mnist_data();
    train_out  = func(train_x);
    test_out  = func(test_x);
    save (['saved_data\',filename], 'train_out', 'test_out');

end


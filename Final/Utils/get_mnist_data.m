function [ train_x, train_y, test_x, test_y ] = get_mnist_data()
%GET_DATA Summary of this function goes here
%   Detailed explanation goes here
load mnist_uint8;

train_x = double(reshape(train_x',28,28,60000))/255;
test_x = double(reshape(test_x',28,28,10000))/255;

train_x = permute(train_x,[2 1 3]);
test_x = permute(test_x,[2 1 3]);

train_y = double(train_y');
test_y = double(test_y');





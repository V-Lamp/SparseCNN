function [ out_cell ] = cell_slice( cell_of_mats , z_start, z_end)
%CELL_SLICE Summary of this function goes here
%   Detailed explanation goes here
out_cell = cell(size(cell_of_mats));
for i = 1: numel(cell_of_mats)
    out_cell{i} = cell_of_mats{i}(:,:,z_start:z_end);
end

end


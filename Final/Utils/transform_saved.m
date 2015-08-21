function [cell_of_mats ] = transform_saved(cell_of_cells )
%TRANSFORM_SAVED Summary of this function goes here
%   Detailed explanation goes here

out_maps= numel(cell_of_cells{1});
map_size = size(cell_of_cells{1}{1});
z = numel(cell_of_cells);
cell_of_mats = cell(out_maps,1);
for i =1: out_maps
    cell_of_mats{i}=zeros([map_size,z]);
    for j = 1:z
        cell_of_mats{i}(:,:,j) = cell_of_cells{j}{i};
    end
end
end


function out = unpad(mat, out_size, pad_size)
out = mat(pad_size(1) + (1:out_size(1)), pad_size(2) + (1:out_size(2)),:);
end
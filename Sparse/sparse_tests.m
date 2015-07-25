n_in = 2;
n_out = 1;
size = 8;

rng(1)
inmaps = {};
for i = 1:n_in
    inmaps{i} = rand(size);
end

sum_out = 0;
for i = 1:n_in
    sum_out = sum_out + inmaps{i};
end

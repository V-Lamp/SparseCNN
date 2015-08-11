function plot_cnn( cnn )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    n_l = 6;
    for l = 1:n_l - 1
        output = cnn.layers{l}.a;
        n_out = max(size(output,1),size(output,2)) ;
        for i = 1:n_out
            cnt = n_out*(l-1)+i;
            h = better_subplot(n_l, n_out, cnt);  
            to_plot = output{i}(:,:,1);
            subimage(scaleMat2Gray(to_plot))            
            axis off;
        end
    end
    h = better_subplot(n_l, 1, n_l);
    to_plot = cnn.o(:,1)';
    to_plot = scaleMat2Gray(to_plot);
    subimage(to_plot)

end


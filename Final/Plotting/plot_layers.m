function plot_layers(layers_outputs, overwrite)
%PLOT_LAYERS plots images and histograms for the given layers
% Plots the two in separate windows
if overwrite
    h_im=figure(1000);
else
    h_im = figure();
end
set(h,'units','normalized','outerposition',[0 0 0.5 1])

n_layers = numel(layers_outputs);
for j = 1:n_layers
    layer = layers_outputs{j};
    if iscell(layer)
        n_out = numel(layer);
        for i = 1:n_out
            cnt = n_out*(i-1)+i;
            h = better_subplot(n_layers, n_out, cnt);  
            to_plot = layer{i}(:,:,1);
            subimage(scaleMat2Gray(to_plot))           
            axis off;
        end
    else        
        cnt = 1;
        h = better_subplot(n_layers, 1, cnt);  
        to_plot = layer(:,:,1);
        subimage(scaleMat2Gray(to_plot))           
        axis off;
    end
end
%% 
if overwrite
    h_hist = figure(1001);
else
    h_hist = figure();
end
set(h,'units','normalized','outerposition',[0.5 0 0.5 1])

n_layers = numel(layers_outputs);
for j = 1:n_layers
    layer = layers_outputs{j};
    if iscell(layer)
        n_out = numel(layer);
        for i = 1:n_out
            cnt = n_out*(i-1)+i;
            h = better_subplot(n_layers, n_out, cnt);  
            to_plot = layer{i}(:,:,1);
            hist(to_plot(:),256/2)         
            axis off;
        end
    else        
        cnt = 1;
        h = better_subplot(n_layers, 1, cnt);  
        to_plot = layer(:,:,1);
        hist(to_plot(:),256/2)           
        axis off;
    end
end

end


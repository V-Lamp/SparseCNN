function plot_layers(layers_outputs, overwrite)
%PLOT_LAYERS plots images and histograms for the given layers
% Plots the two in separate windows
if overwrite
    h_im=figure(1000);
else
    h_im = figure();
end

set(h_im,'Color',[0.8 0.9 1]);
%set(gca,'Color',[0.8 0.8 1]);
set(h_im,'units','normalized','outerposition',[0 0 0.5 1])

n_layers = numel(layers_outputs);
for j = 1:n_layers
    layer = layers_outputs{j};    
    n_out = numel(layer);
    for i = 1:n_out
        cnt = n_out*(j-1)+i;
        h = better_subplot(n_layers, n_out, cnt,1.2);  
        to_plot = layer{i}(:,:,1);
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
set(h_hist,'units','normalized','outerposition',[0.5 0 0.5 1])

n_layers = numel(layers_outputs);
for j = 1:n_layers
    layer = layers_outputs{j};  
    n_out = numel(layer);
    for i = 1:n_out
        cnt = n_out*(j-1)+i;
        h = better_subplot(n_layers, n_out, cnt,0.9);  
        to_plot = layer{i}(:,:,1);
        hist(to_plot(:),256/4)         
    end
    
end

end


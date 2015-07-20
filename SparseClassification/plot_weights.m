function plot_weights(x)
GP=global_parameters;
m=length(x);

if min(GP.imDims)==1
  plot(x)
  axis('tight'),set(gca,'XTick',[],'YTick',[]);
else
  if GP.onoff
    m=m/2;
    imagesc(reshape(x(1:m),GP.imDims)'-reshape(x(m+1:2*m),GP.imDims)'),
  else
    imagesc(reshape(x,GP.imDims)'),   
  end
  axis('equal','tight'),set(gca,'XTick',[],'YTick',[]);
end
  
  

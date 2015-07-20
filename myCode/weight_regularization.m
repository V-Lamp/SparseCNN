n=16;m=5;
img = rand(n)
mask = (rand(m)-0)*10000
%mask = (rand(m)-0.5)*10000
w=convmtx2(mask,size(img));
v=w;
n_out=size(w,1)
for i =1:n_out
    v(i,:) = v(i,:)/(max(v(i,:))*n_out);
    w(i,:) = w(i,:)./sum(w(i,:));
end
wReg = mask./sum(mask(:));
vReg = mask./max(mask(:));
matwReg=convmtx2(wReg,size(img));
matvReg=convmtx2(vReg,size(img));

diffw=matwReg(:)-w(:);
diffv=matvReg(:)-v(:);
mean(matwReg(:)-w(:))
hist(diffw,100)
waitforbuttonpress
hist(diffv,100)

%C1 = conv2(img,mask);
%C2=reshape(expanded*img(:),size(mask)+size(img)-1);




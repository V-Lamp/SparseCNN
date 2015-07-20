img = rand(6,6)
mask = rand(3)
mask = mask/sum(mask(:))
C1 = conv2(img,mask);
size(C1)
T = convmtx2(mask,size(img));
size(T)
C2=reshape(T*img(:),size(mask)+size(img)-1);
size(C2)
C1-C2;
size(mask)+size(img)-1
%T = convmtx2(H,m,n) returns the convolution matrix T for the matrix H. 
%If X is an m-by-n matrix, 
%then reshape(T*X(:),size(H)+[m n]-1) 
%is the same as conv2(X,H).


w=T;
v=w;
n_out=size(w,1)
m=size(X,2)
for i =1:n_out
    v(i,:) = v(i,:)/(max(v(i,:))*n_out);
    w(i,:) = w(i,:)./sum(w(i,:));
end
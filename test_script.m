clc;
close all
tSize=16;
testImg=[ones(tSize,tSize/2),ones(tSize,tSize/2)*0.999];
testImg(tSize/2:tSize,tSize/2:tSize)=1;
testImg = testImg';

[lenna,map]=imread('lenna.jpg');
lenna=mean(lenna,3);

po=0;
img=10^po*mat2gray(lenna );

wSize=4;
w0=[ones(wSize,wSize/2),3*ones(wSize,wSize/2)];

w1=[1,0,1;
    0,-4,0;
    1,0,1];
w1p=[1,0,1;
    0,4,0;
    1,0,1];

w2=[ 0, 1, 0;
    1,-4, 1;
    0, 1, 0];
w2p=[ 0, 1, 0;
    1,4, 1;
    0, 1, 0];

w3=[ 1, 1, 1;
    0, 0, 0;
    -1,-1,-1];
w3=-w3;
w4=[ 0, 1, 0;
    0, 0, 0;
    0,-1, 0];

w=1*w3;
w=w+0.0*ones(3);

 
X={img};
w={w};
convy=DIM_Conv(X,w,1);
convy=convy{1};

% ws=SplitMatrix(w);
% wp = ws{1};
% wn = ws{2};
% yp= conv2(img, wp);
% yn= conv2(img,wn);
% y = yp-yn;
% PlotAsImages({img,convy,yp,yn,y},{'original','convolution','pos conv','neg conv','summed'},false)

dimy=DIM_Conv(X,w,2);
dimy=dimy{1};
diff=scaleMat2Gray(convy,12)-scaleMat2Gray(dimy,12);
PlotAsImages({img,convy;dimy,diff},{'original','convolution';'dim','conv-DIM'},false)
PlotAsHistograms({img,convy;dimy,diff},{'original','convolution';'dim','conv-DIM'},false)




function scaled = scaleMat2Gray(img,stdmult)
    if nargin<2
        stdmult=6;
    end
    m=mean(img(:));
    s=std(img(:));
    scaled=(img-m)./(stdmult*s);
    scaled=scaled+0.5;
    msc=mean(scaled(:));
    ssc=std(scaled(:));
    scaled=max(min(scaled,1),0);
    scaled=mat2gray(scaled);
end
function out = pad_with_fade(mat, pad_size)
        [a,b,z] = size(mat);
        c = pad_size(1); d = pad_size(2);
        fade=[1:c]./c;
        out = padarray(mat,[c,d],'replicate');%'symmetric');
        out(1:c,:,:)=out(1:c,:,:).*repmat(fade',1,b+2*d,z);
        out(a+c+[1:c],:,:)=out(a+c+[1:c],:,:).*repmat(flipud(fade'),1,b+2*d,z);
        fade=[1:d]./d;
        out(:,1:d,:)=out(:,1:d,:).*repmat(fade,a+2*c,1,z);
        out(:,b+d+[1:d],:)=out(:,b+d+[1:d],:).*repmat(fliplr(fade),a+2*c,1,z); 
end
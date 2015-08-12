function Y = DIM_sep_mask_splitting( X,w,Y,iterations )
%DIM_SEP_MASK_SPLITTING Summary of this function goes here
%   Detailed explanation goes here
%split masks

wpos=cell(size(w));
wneg=cell(size(w));
[nOutMaps, nInMaps] = size(w);
for inM=1:nInMaps
    for outM=1:nOutMaps
        wpos{outM,inM} = max(w{outM,inM},0);
        wneg{outM,inM} = -min(w{outM,inM},0);
    end

end
%call plain dim twice
% TODO: check about rotating masks in original vs others
ypos = DIM_original(X,wpos,Y,iterations);
yneg = DIM_original(X,wneg,Y,iterations);
%subtract outputs
for i = 1:nOutMaps
    Y{i}= ypos{i} - yneg{i};
end
end


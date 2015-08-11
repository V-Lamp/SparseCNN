function Y = DIM_sep_mask_splitting( X,w,Y,iterations )
%DIM_SEP_MASK_SPLITTING Summary of this function goes here
%   Detailed explanation goes here
%split masks

wpos={};
wneg={};

for inM=1:nInMaps
    for outM=1:nOutMaps
        [w{outM,inM},isSp]=SplitMatrix(w{outM,inM});
        %TODO:...
    end

end
%call plain dim twice
% TODO: check about rotating masks in original vs others
ypos = DIM_original(X,wpos,Y,iterations);
yneg = DIM_original(X,wneg,Y,iterations);
%subtract outputs
Y= ypos - yneg;
end


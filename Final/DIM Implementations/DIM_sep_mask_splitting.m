function Y = DIM_sep_mask_splitting( X,w,Y,iterations )
%DIM_SEP_MASK_SPLITTING Summary of this function goes here
%   Detailed explanation goes here
%split masks

wpos=cell(size(w));
wneg=cell(size(w));
Xpos = cell(size(X));
%Xneg = cell(size(X));

[nOutMaps, nInMaps] = size(w);
% splitX = any(cellfun(@(M) any(M<0),X));
% if ~splitX
%     Xpos = X;
% end
for inM=1:nInMaps
    for outM=1:nOutMaps
        wpos{outM,inM} = max(w{outM,inM},0);
        wneg{outM,inM} = -min(w{outM,inM},0);
    end    
%     if splitX        
%         Xpos{inM} = -min(X{inM},0);
%         if isZero(Xpos{inM})
%             Xpos{inM} =[];
%         end
%         Xneg{inM} = max(X{inM},0);
%         if isZero(Xneg{inM})
%             Xneg{inM} =[];
%         end
%     end
end
%call plain dim twice
% TODO: check about rotating masks in original vs others
%if splitX
%     ypos = DIM_padding(Xpos,wpos,Y,iterations)+DIM_padding(Xneg,wneg,Y,iterations);
%     yneg = DIM_padding(Xpos,wneg,Y,iterations)+DIM_padding(Xneg,wpos,Y,iterations);
%end

ypos = DIM_padding_valid(X,wpos,Y,iterations);
yneg = DIM_padding_valid(X,wneg,Y,iterations);


%subtract outputs
for i = 1:nOutMaps
    
    Y{i}= ypos{i} - yneg{i};
%     disp([i,min(ypos{i}(:)),min(yneg{i}(:))])
%     disp([i,mean(ypos{i}(:)),mean(yneg{i}(:))])
%     disp([i,max(ypos{i}(:)),max(yneg{i}(:))])
%     
%     disp('= = = = = = = = = = = = = = = = = = = ')
%     disp([i,min(Y{i}(:))])
%     disp([i,mean(Y{i}(:))])
%     disp([i,max(Y{i}(:))])
%     disp('======================================')
end
end


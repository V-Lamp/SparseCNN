clear all;
batch=1000;
inMaps=3;
colChannels=1;
randImg=rand(32,32,colChannels,inMaps,batch);
randMask=rand(3,3,1,1);
convnOut=convn(randImg,randMask,'same');
loopConv=zeros(size(randImg));
for i=1:batch
    for j=1:inMaps
        for k = 1:colChannels
            loopConv(:,:,k,j,i)=conv2(randImg(:,:,k,j,i),randMask(:,:,k,1),'same');
        end
    end
    %conv2Out(:,:,:,i)=convn(randImg(:,:,:,i),randMask,'same');
end
size(convnOut)
size(loopConv)
sum(convnOut(:)~=loopConv(:))
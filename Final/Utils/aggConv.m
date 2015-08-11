function [ outMaps ] = aggConv( inMaps,w,shape,outMaps )
%AGGCONV Summary of this function goes here
%   Detailed explanation goes here
[nOutMaps,nInMaps]=size(w);

assert(nInMaps==numel(inMaps));
if nargin<4 || isempty(outMaps)
    outMaps=cell(nOutMaps,1);
else
    assert(nOutMaps==numel(outMaps));
end

for i=1:nOutMaps
    outMaps{i} = convn(inMaps{1},w{i,1},shape);
    for j = 2 : nInMaps   %  for each input map
        outMaps{i} = outMaps{i} + convn(inMaps{j},w{i,j},shape);
    end
end
end


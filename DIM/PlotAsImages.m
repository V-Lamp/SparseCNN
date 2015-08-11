function [  ] = PlotAsImages( CellOfMats,Titles, overwrite )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    overwrite = true;
end
if nargin < 2
    Titles = {};
end
if overwrite
    h=figure(1000);
else
    h = figure();
end
set(h,'units','normalized','outerposition',[0 0 0.5 1])

[rLen,cLen]=size(CellOfMats);
cnt=1;
for i=1:rLen
    for j=1:cLen
        if ~isempty(CellOfMats{i,j})
            cnt = cLen*(i-1) + j;
            h = better_subplot(rLen,cLen,cnt);            
            subimage(scaleMat2Gray(CellOfMats{i,j}))
            axis off;
            if ~isempty(Titles)
                if ~isempty(Titles{i,j})
                    title(Titles{i,j})
                end
            end
        end
    end
end




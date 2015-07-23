function [  ] = PlotAsImagesAndHist( CellOfMats,Titles, overwrite )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    overwrite = true;
end

if overwrite
    h=figure(999);
else
    h = figure();
end
set(h,'units','normalized','outerposition',[0 0 1 1])

[rLen,cLen]=size(CellOfMats);
cnt=1;
for i=1:rLen
    for j=1:cLen        
        if ~isempty(CellOfMats{i,j})
            cnt = cLen*2*(i-1) + j*2-1
            
            subplot(rLen,cLen*2,cnt)
            subimage(scaleMat2Gray(CellOfMats{i,j}))
            if ~isempty(Titles)
                if ~isempty(Titles{i,j})
                    title(Titles{i,j})
                end
            end
            
            subplot(rLen,cLen*2,cnt+1)
            hist(CellOfMats{i,j}(:),256/2)
            if ~isempty(Titles)
                if ~isempty(Titles{i,j})
                    title(Titles{i,j})
                end
            end
        end
    end
end




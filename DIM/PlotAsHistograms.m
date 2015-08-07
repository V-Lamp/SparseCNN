function [  ] = PlotAsHistograms( CellOfMats,Titles, overwrite )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3
    overwrite = true;
end

if overwrite
    h=figure(1001);
else
    h = figure();
end
set(h,'units','normalized','outerposition',[0.5 0 0.5 1])

[rLen,cLen]=size(CellOfMats);
cnt=1;
for i=1:rLen
    for j=1:cLen
        if ~isempty(CellOfMats{i,j})
            h = subplot(rLen,cLen,cnt);
            p = get(h, 'pos');
            scale= 0.20;
            p(1) = p(1)-p(3)*scale/2;
            p(2)= p(2)- p(4)*scale/2;
            p(3) = p(3)*(1+scale);
            p(4) = p(4)*(1+scale);
            set(h, 'pos', p);
            cnt=cnt+1;
            hist(CellOfMats{i,j}(:),256/2)
            if ~isempty(Titles)
                if ~isempty(Titles{i,j})
                    title(Titles{i,j})
                end
            end
        end
    end
end
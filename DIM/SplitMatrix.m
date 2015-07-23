function [splitted, isSplitted]=SplitMatrix(A)
if any(A(:)< 0)
    isSplitted=true;
    splitted={max(A,0),-min(A,0)};
    %assert(isequal(A,(splitted{1}-splitted{2})),'wrong splitting');
else
    isSplitted=false;
    splitted=A;
end
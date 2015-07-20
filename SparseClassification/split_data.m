function [inTrain,inTest]=split_data(numPatterns,proportionTrain,fixedSplit)
if fixedSplit  %data has fixed training and testing sets
  inTrain=1:fixedSplit;
  inTest=fixedSplit+1:numPatterns;
else %data is randomly partitioned into training and testing sets
  randorder=randperm(numPatterns)
  numPatternsTrain=ceil(proportionTrain*numPatterns);
  numPatternsTest=numPatterns-numPatternsTrain;
  inTrain=randorder(1:numPatternsTrain);
  inTest=randorder(1+numPatternsTrain:numPatterns);
end

function [W,V,classDict,D]=test_sparse_classifier(W,V,classDict,D,show,range)
RandStream.setDefaultStream(RandStream.create('mt19937ar','seed',0));
global_parameters
addpath('~/Utils/Matlab/Toolboxes/L1benchmark/L1Solvers/')
addpath('~/Utils/Matlab/Toolboxes/smallbox_1.9/solvers/')
addpath('~/Utils/Matlab/Toolboxes/smallbox_1.9/toolboxes/SparseLab2.1-Core/Solvers');
%addpath('~/Utils/Matlab/Toolboxes/smallbox_1.9/toolboxes/alps/ALPS/')
%addpath('~/Utils/Matlab/Toolboxes/Focuss-cndl');

%LOAD AND PREPROCESS DATA
[data,class,inTrain,inTest]=load_dataset;
data=norm_dictionary(data')'; %normalise data: which will normalise dictionary elements and testing data

%DEFINE CLASSIFIER WEIGHTS
if nargin<3 || isempty(W) || isempty(V) || isempty(classDict) 
  [W,V,classDict]=define_dictionary_weights(data(:,inTrain),class(inTrain));
end
if nargin<4 || isempty(D)
  D=define_decoding_weights(W,V,classDict,data(:,inTrain),class(inTrain));
end

%TEST PERFORMANCE OF CLASSIFIER ON TRAINING AND TESTING DATA
if nargin<5 || isempty(show), show=0; end
if nargin<6 || isempty(range), range=[1:5]; end
if show
  %show results graphically for a select few elements from either the test or training sets
  if range(1)<0
    calc_classification_error(W,V,D,classDict,data(:,inTrain(abs(range))),class(inTrain(abs(range))),show);
  else
    calc_classification_error(W,V,D,classDict,data(:,inTest(range)),class(inTest(range)),show);
  end
else
  %randomly select up to 2000 elements from the training data to use for testing
  %the classifier
  randorder=randperm(length(inTrain));
  inTrainToTest=inTrain(randorder(1:min(length(inTrain),2000)));
  calc_classification_error(W,V,D,classDict,data(:,inTrainToTest),class(inTrainToTest),0);
  
  %test the classifier against all elements in the test set
  calc_classification_error(W,V,D,classDict,data(:,inTest),class(:,inTest),0);
  
  %calc_classification_error(W,V,D,classDict,data(:,inTest(1:100)),class(inTest(1:100)),0);
end

function calc_classification_error(W,V,D,classDict,data,class,show);
GP=global_parameters;
numPatterns=length(class);
numClasses=max(class);
[n,m]=size(W);
disp(['testing performance on data set with ',int2str(numPatterns),' elements, in ',int2str(numClasses),' classes']);

%TEST classification performance by comparing the class predicted by the output of the
%network with the true class defined in the dataset, for all patterns in the test set
maxk=min(15,n);
eAll=zeros(1,numPatterns);
sAll=zeros(1,numPatterns);
errCountkNN=zeros(1,maxk);
errCountMax=0;
errCountSum=0;
errCountErr=0;

extraStats=0;
if extraStats
  errSparsity=[];
  repSparsity=[];
  errError=[];
  repError=[];
  errRatio=[];
  repRatio=[];
end
execTime=0;

for pattern=1:numPatterns
  if rem(pattern,100)==0, fprintf(1,'.%i.',pattern); end

  %calculate coefficients for/response to input image
  x=data(:,pattern);
  
  [y,e,s,nmse,execTime,sTrace]=calc_sparse_representation(W,V,x,classDict,execTime);
  eAll(pattern)=mean(nmse); %store reconstruction error to calc mean later
  sAll(pattern)=s; %store representation sparsity to calc mean later
  classExpected=class(pattern);
  
  %classification based maximum response
  [val,ind]=max(y);
  classGenerated=classDict(ind);
  if classExpected~=classGenerated, errCountMax=errCountMax+1; end
  
  %classification based k-maximum responses
  [val,ind]=sort(y,'descend');
  for k=1:maxk;
    counts=histc(classDict(ind(1:k)),[0.5:1:numClasses+0.5]);
    [val,classGenerated]=max(counts);
    if classExpected~=classGenerated, errCountkNN(k)=errCountkNN(k)+1; end
  end

  %classification based on sum of responses
  z=D*y;
  [val,classGenerated]=max(z);
  vals=sort(z,'descend');
  if classExpected~=classGenerated, errCountSum=errCountSum+1; end
  
  %classification based on reconstruction error
  switch GP.network
    case 'subnets'
      %classify based on which sub-dictionary has lowest reconstruction error
      [val,classGenerated]=min(nmse);
      if classExpected~=classGenerated, errCountErr=errCountErr+1; end
    case 'single'
      %calc reconstruction error for nodes of a single class:
      for c=1:numClasses
        ind=logical(classDict==c);
        yclass=zeros(n,1);
        yclass(ind)=y(ind); %y values for one class only
        err(c)=norm(x-(V'*yclass),2);
      end
      %classify based on which sub-dictionary has lowest reconstruction error
      [val,classGenerated]=min(err);
      if classExpected~=classGenerated, errCountErr=errCountErr+1; end
  end

  if extraStats
    if classExpected~=classGenerated
      errRatio=[errRatio,vals(1)/vals(2)];
      errSparsity=[errSparsity,s]; 
      errError=[errError,nmse]; 
    else
      repRatio=[errRatio,vals(1)/vals(2)];
      repSparsity=[repSparsity,s]; 
      repError=[repError,nmse]; 
    end
  end
  
  %plot results
  if show
    figure(pattern+show-1)
    plot_result(x,y,sTrace,W,classDict,classExpected);
  end
end
disp(' ');
if extraStats
  %report sparsity and error for correctly and incorrectly classified patterns
  disp([' errSparsity=',num2str(nanmean(errSparsity)),' repSparsity=',num2str(nanmean(repSparsity)),' / errError=',num2str(nanmean(errError)),' repError=',num2str(nanmean(repError)),' / errRatio=',num2str(nanmean(errRatio)),' repRatio=',num2str(nanmean(repRatio))]);
end

%calculate  percentage classification errors
errkNN=100.*errCountkNN./numPatterns
errMax=100*errCountMax/numPatterns;
errSum=100*errCountSum/numPatterns;
errErr=100*errCountErr/numPatterns;
%report results
disp(' errMax=  errSum=  errErr=  execTime=  Hoyer=  NMSE=');
disp([num2str(errMax),' ',num2str(errSum),' ',num2str(errErr),' ',num2str(execTime),' ',num2str(nanmean(sAll)),' ',num2str(nanmean(eAll))]);



function plot_result(x,y,sTrace,W,class,classExpected)
%plot input image, convergence of dim competition, and most active basis vectors
clf
GP=global_parameters;
[n,m]=size(W);
%p=sqrt(m);

%plot change in sparsity over time, and final responses
numActive=length(find(y>0.1*max(y)))
numToPlot=min(max(3,numActive),6);
maxsubplot(2,numToPlot,numToPlot+3:2*numToPlot,0.15),plot(y'),axis('tight')
maxsubplot(2,numToPlot,numToPlot+2,0.15); plot(sTrace','r','LineWidth',2);

%plot input image
maxsubplot(2,numToPlot,numToPlot+1,0.15),
plot_weights(x);
title([num2str(classExpected-1)]);

%plot most active basis vectors
[val,ind]=sort(y,1,'descend');
for i=1:min(numActive,6)
  maxsubplot(2,numToPlot,i,0.15)
  plot_weights(W(ind(i),:));
  title([num2str(class(ind(i))-1),': ',num2str(val(i))]);
end
drawnow;




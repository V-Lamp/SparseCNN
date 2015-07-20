function [data,class,inTrain,inTest]=load_dataset()
GP=global_parameters;
fixedSplit=0;
proportionTrain=0.75; %proportion of data to use for training (the rest is use for testing)

switch GP.data_set
  case 'USPS'
    load('../Data/usps.mat');
    fixedSplit=7291;
    classIndex=257; dataIndeces=1:256; numClasses=10; numExemplars=9298; intensity=1;
    class=data(:,classIndex)';
    data=data(:,dataIndeces)';
    
  case 'ISOLET'
    data=load('../Data/UCIClassification/isolet1+2+3+4.data');
    test=load('../Data/UCIClassification/isolet5.data');
    fixedSplit=size(data,1);
    data=[data;test];
    classIndex=618; dataIndeces=1:617; numClasses=26; numExemplars=7797; 
    class=data(:,classIndex)';
    data=data(:,dataIndeces)';

  case 'MNIST'
    trainingImagesPerDigit=2000;
    data=[];class=[];
    for i=1:10
      load(['../Data/LeCun-MNIST_handwrittendigits/digit',int2str(i-1)]);
      class=[class,i*ones(1,trainingImagesPerDigit)];
      data=[data,D(1:trainingImagesPerDigit,:)'];
    end
    fixedSplit=size(data,2);
    for i=1:10, 
      load(['../Data/LeCun-MNIST_handwrittendigits/test',int2str(i-1)]); 
      class=[class,i*ones(1,size(D,1))];
      data=[data,D'];
    end

  case 'NORB'
    datafile='../Data/SmallNORB/smallnorb-5x46789x9x18x6x2x96x96-training-dat.mat';
    catfile='../Data/SmallNORB/smallnorb-5x46789x9x18x6x2x96x96-training-cat.mat';
    [data,classTrain]=read_norb_data(datafile,catfile);
    fixedSplit=size(data,2);
    datafile='../Data/SmallNORB/smallnorb-5x01235x9x18x6x2x96x96-testing-dat.mat';
    catfile='../Data/SmallNORB/smallnorb-5x01235x9x18x6x2x96x96-testing-cat.mat';
    [test,classTest]=read_norb_data(datafile,catfile);
    data=[data,test];
    class=[classTrain,classTest];
    
  case 'CIFAR10'
    alldata=[]; class=[];
    for i=1:5
      load(['../Data/cifar-10/data_batch_',int2str(i)]);
      data=convert_to_grey(data,[32,32]);
      alldata=[alldata,data'];
      class=[class,labels'];
    end
    fixedSplit=size(alldata,2);
    load('../Data/cifar-10/test_batch');
    data=convert_to_grey(data,[32,32]);
    alldata=[alldata,data'];
    class=[class,labels'];
    data=alldata;
    class=double(class);

 case 'ARTIF'
    [data,class]=artificial_data;
    fixedSplit=5;

  otherwise
    disp('ERROR: unknown data set');
end

%ensure class labels are sequentially numbered starting from 1
class=class+max(0,1-min(class));
k=0;
for c=unique(class)
  k=k+1;
  class(class==c)=k;
end
%scale data to range between 0 and 1
data=data-nanmin(nanmin(data));
data=data./nanmax(nanmax(data));
data(isnan(data))=0; %replace any missing values with zeros

if GP.onoff
  data=data_preprocess_on_off(data);
elseif GP.neg
  [poo,data]=data_preprocess_on_off(data);
end

%split data into two sub-sets. inTrain and inTest provide in indeces of these datasets
[inTrain,inTest]=split_data(length(class),proportionTrain,fixedSplit);




function [data,class]=read_norb_data(datafile,catfile)
numPatterns=200;%24300;
fprintf(1,'loading NORB database: ');
fid=fopen(catfile,'r');
for p=1:5 %read header information - and ignore it
  fread(fid,4,'uchar'); 
end
class=fread(fid,numPatterns,'int')'; 
fclose(fid);

fid=fopen(datafile,'r');
for p=1:6 %read header information - and ignore it
  fread(fid,4,'uchar'); 
end
%data=zeros((96*96)*0.25^2,numPatterns);
data=zeros(96*96,numPatterns);
for i=1:numPatterns
  if rem(i,1000)==0, fprintf(1,'.%i.',i); end
  for j=1:2 %take one image in each pair
    I=fread(fid,96*96);
  end
  I=255-I;
  %I=I-min(min(I));I=I./max(max(I));
  %Itmp=reshape(I,96,96); Itmp=imresize(Itmp, 0.25); I=Itmp;
  data(:,i)=I(:);   
end
fclose(fid);


function dataOut=convert_to_grey(data,imSize)
[n,m]=size(data);
dataOut=zeros(n,m/3);
for j=1:n
  for colour=1:3
    I(:,:,colour)=reshape(data(j,1+(colour-1)*prod(imSize):colour*prod(imSize)),imSize);
  end
  Ig=rgb2gray(im2double(I));
  dataOut(j,:)=Ig(:)';
end

  
function [X,data]=data_preprocess_on_off(data)
%[numFeatures,numPatterns]=size(data);

data=2.*bsxfun(@minus,data,mean(data)); 
  
xOn=data;
xOn(xOn<0)=0;
xOff=-data;
xOff(xOff<0)=0;
X=[xOn;xOff];



function [data,class]=artificial_data

if 0
I=zeros(11,11);
%I(6,1:6)=1;I(6:11,6)=1;
I(1,1:11)=1;
data(:,1)=I(:);

I=zeros(11,11);
%I(6,1:6)=1;I(1:6,6)=1;
I(1,1:11)=1;I(1:11,1)=1;
data(:,2)=I(:);

I=zeros(11,11);
%I(6,6:11)=1;I(6:11,6)=1;
I(1,1:11)=1;I(1:11,1)=1;I(11,1:11)=1;
data(:,3)=I(:);

I=zeros(11,11);
%I(6,6:11)=1;I(1:6,6)=1;
I(1,1:11)=1;I(1:11,1)=1;I(11,1:11)=1;I(1:11,11)=1;
data(:,4)=I(:);

I=zeros(11,11);
%I(6,1:11)=1;I(1:11,6)=1;
I(11,1:11)=1;I(1:11,11)=1;
data(:,5)=I(:);

class=[1:5];

data=[data,data];
class=[class,class];

end

I=zeros(11,11);
I(6,6)=1;
data(:,1)=I(:);

I=zeros(11,11);
I(5:7,5:7)=1;
data(:,2)=I(:);

I=zeros(11,11);
I(4:8,4:8)=1;
data(:,3)=I(:);

class=[1,1,2];

if 0
for j=6:10
  for i=1:121
    if rand<0.125
      if data(i,j)>0.5, data(i,j)=0;
      else data(i,j)=1; end
    end
  end
end
end
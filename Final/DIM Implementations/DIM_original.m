function [Y,E,R,Ytrace,Etrace,Rtrace]=dim_activation_conv_recurrent...
            (X,w,Y,iterations,v,downsample)
% w = a cell array of size {N,M}, where N is the number of distinct neuron types
%     and M is the number of input channels. Each element {i,j} of the cell
%     array is a 2-dimensional matrix (a convolution mask) specifying the
%     synaptic weights for neuron type i's RF in input channel j.

% X = a cell array of size {M}. Each element {j} of the cell array is a
%     2-dimensional matrix specifying the bottom-up input to that channel j of
%     the current processing stage (external inputs targetting the error
%     nodes). If inputs arrive from more than one source, then each source
%     provides a different cell in the array. Input values that change over
%     time can be presented using a 3-d matrix, where the 3rd dimension is time.

% Y = a cell array of size {N}. Each element {i} of the cell array is a
%     2-dimensional matrix specifying prediction node activations for type i
%     neurons.

% R = a cell array of size {M}. Each element {j} of the cell array is a
%     2-dimensional matrix specifying the reconstruction of the input channel j.
%     These values are also the top-down feedback that should modulate
%     activity in preceeding processing stages of a hierarchy.

% E = a cell array of size {M}. Each element {j} of the cell array is a
%     2-dimensional matrix specifying the error in the reconstruction of the
%     input channel j.

% downsample = an N element vector of integer values which defines which
%     prediction node values are to be set to zero, and hence, be ignored. This
%     is a method of reducing the density of prediction nodes across the image
%     (ideally, rather than performing convolution at every pixel location and
%     then setting some values to zero, it would be possible to only calulate
%     the filter outputs at certain locations). A value of 1 means keep all
%     values, 2 means keep every alternate value, 3 means keep every third
%     value, and so on. Default is 1 for each type of neuron.  

% iterations = the number of iterations of the DIM algorithm to perform. Default
%     is 50.



[a,b,z]=size(X{1});
[nOutMaps,nInMaps]=size(w);
nInputChannels=length(X);
[c,d]=size(w{1,1});

%==============================
for inM=1:nInMaps
    for outM=1:nOutMaps
        w{outM,inM}=rot90(w{outM,inM},2);
    end
end
%==============================


%set parameters
epsilon1=1e-5;
epsilon2=1e-3;

%disp('dim_activation_conv_recurrent');
%disp(['  epsilon1=',num2str(epsilon1),' epsilon2=',num2str(epsilon2)]);

if nargin<3 || isempty(Y), %initialise prediction neuron outputs to zero
  for i=1:nOutMaps
    Y{i}=zeros(a,b,'single');
  end  
end

if nargin<4 || isempty(iterations), iterations=50; end

if nargin<5 || isempty(v)
  %set feedback weights equal to feedforward weights normalized by maximum value
  for i=1:nOutMaps
    %calc normalisation values by taking into account all weights contributing to
    %each RF type
    maxVal=0;
    for j=1:nInMaps
      if ~isempty(w{i,j})
        maxVal=max(maxVal,max(max(abs(w{i,j}))));
      end
    end

    %apply normalisation to calculate feedback weight values.
    for j=1:nInMaps
        v{i,j}=abs(w{i,j})./max(1e-6,maxVal);
        %v{i,j}=(w{i,j})./max(1e-6,maxVal);
    end
  end
end

if nargin<6 || isempty(downsample)
    downsample=ones(1,nOutMaps); 
end
if length(downsample)<nOutMaps, %allow use to specify same value for multiple neuron types
  downsample(length(downsample)+1:nOutMaps)=downsample(length(downsample));
end

%try to speed things up
if exist('convnfft')==2 && min(c,d)>15 && min(a,b)>15
  conv_fft=1;%use fft version of convolution for large images and/or
             %masks. see:
             %www.mathworks.com/matlabcentral/fileexchange/24504-fft-based-convolution  
else
  conv_fft=0;%use standard MATLAB conv2 function for smaller images and/or masks,
             %or if faster function is not installed
end

%FF weights are rotated so that convolution can be used to apply the filtering
%(otherwise the mask gets rotated every iteration!)
for j=1:nInMaps
  for i=1:nOutMaps
    w{i,j}=rot90(w{i,j},2);
  end
end

%//////////////////////////////////////////////////////////////////
%////////////////////Main Loop/////////////////////////////////////
%//////////////////////////////////////////////////////////////////

%iterate DIM equations to determine neural responses
%fprintf(1,'dim_conv(%i): ',conv_fft);
for t=1:iterations
  %fprintf(1,'.%i.',t);
    
  %copy previous output values to inputs, to provide recurrent input
  for i=1:nOutMaps
    X{nInputChannels+i}=Y{i};
  end
  
  %update error-detecting neuron responses
  for j=1:nInMaps
    %calc predictive reconstruction of the input
    R{j}=zeros(a,b,'single');%reset reconstruction of input
    for i=1:nOutMaps
      %sum reconstruction over each RF type
      if ~(isempty(v{i,j}) || iszero(v{i,j})) %skip empty filters: they don't add anything
        if conv_fft==1
          R{j}=R{j}+convnfft(Y{i},v{i,j},'same');
        else
          R{j}=R{j}+conv2(Y{i},v{i,j},'same');
        end
      end
    end
    %calc error between reconstruction and actual input: using values of input 
    %that change over time (if these are provided)
    E{j}=X{j}(:,:,min(t,size(X{j},3)))./max(epsilon2,R{j});
    %E{j}=tanh(X{j}(:,:,min(t,size(X{j},3))))./max(epsilon2,R{j});
    if nargout>4
      Etrace{j}(:,:,t)=E{j};%record response over time
    end
    if nargout>5
      Rtrace{j}(:,:,t)=R{j};%record response over time
    end
  end

  %update prediction neuron responses
  for i=1:nOutMaps
    dY=single(0);
    for j=1:nInMaps
      %sum inputs to prediction neurons from each channel
      if ~(isempty(w{i,j}) || iszero(w{i,j})) %skip empty filters: they don't add anything
        if conv_fft==1
          %input=input+max(0,convnfft(E{j},w{i,j},'same')); %sensitive to phase
          %input=input+abs(convnfft(E{j},w{i,j},'same')); %invariant to phase
          dY=dY+convnfft(E{j},w{i,j},'same'); %sensitive to phase
        else
          %input=input+max(0,conv2(E{j},w{i,j},'same')); %sensitive to phase
          %input=input+abs(conv2(E{j},w{i,j},'same')); %invariant to phase
          dY=dY+conv2(E{j},w{i,j},'same'); %sensitive to phase
        end
      end
    end
    dY=(dY-1).*0.2 + 1;
    %modulate prediction neuron response by current input:
    Y{i}=max(epsilon1,Y{i}).*dY; 
    %Y{i}=max(epsilon1,Y{i}.*input); 
    for ds=1:downsample(i)-1
      Y{i}(ds:downsample(i):a,:)=0;
      Y{i}(:,ds:downsample(i):b)=0;
    end
    if nargout>3
      Ytrace{i}(:,:,t)=Y{i};%record response over time
    end
  end
%   a1_R1=R{1};
%   a2_E1=E{1};
%   a4_Y1=Y{1};
%   a3_Input=input;
% PlotAsImages({R{1};E{1};input;Y{1}},{'R';'E';'input';'Y'})
% pause(0.1)
  
end
end

function bin = iszero(mat)
    bin = ~sum(mat(:));
end


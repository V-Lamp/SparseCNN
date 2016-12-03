function [Y,E,R,Ytrace,Etrace,Rtrace]=DIM_sigmoids...
    (X,w,Y,iterations,v,downsample)
%% Function description
% w = a cell array of size {N,M}, where N is the number of distinct neuron types
%     and M is the number of input channels. Each element {i,j} of the cell
%     array is a 2-dimensional matrix (a convolution mask) specifying the
%     synaptic weights for neuron type i's RF in input channel j.
%
% X = a cell array of size {M}. Each element {j} of the cell array is a
%     2-dimensional matrix specifying the bottom-up input to that channel j of
%     the current processing stage (external inputs targetting the error
%     nodes). If inputs arrive from more than one source, then each source
%     provides a different cell in the array. Input values that change over
%     time can be presented using a 3-d matrix, where the 3rd dimension is time.
%
% Y = a cell array of size {N}. Each element {i} of the cell array is a
%     2-dimensional matrix specifying prediction node activations for type i
%     neurons.
%
% R = a cell array of size {M}. Each element {j} of the cell array is a
%     2-dimensional matrix specifying the reconstruction of the input channel j.
%     These values are also the top-down feedback that should modulate
%     activity in preceeding processing stages of a hierarchy.
%
% E = a cell array of size {M}. Each element {j} of the cell array is a
%     2-dimensional matrix specifying the error in the reconstruction of the
%     input channel j.
%
% downsample = an N element vector of integer values which defines which
%     prediction node values are to be set to zero, and hence, be ignored. This
%     is a method of reducing the density of prediction nodes across the image
%     (ideally, rather than performing convolution at every pixel location and
%     then setting some values to zero, it would be possible to only calulate
%     the filter outputs at certain locations). A value of 1 means keep all
%     values, 2 means keep every alternate value, 3 means keep every third
%     value, and so on. Default is 1 for each type of neuron.
%
% iterations = the number of iterations of the DIM algorithm to perform. Default
%     is 50.

%% initialization
[a,b,z]=size(X{1});
[nOutMaps,nInMaps]=size(w);
nInputChannels=length(X);
[c,d]=size(w{1,1});

%set parameters
epsilon1=1e-5;
epsilon2=1e-5;

%disp('dim_activation_conv_recurrent');
%disp(['  epsilon1=',num2str(epsilon1),' epsilon2=',num2str(epsilon2)]);

% flip weights to be equivalent to aggConv.
% TODO: improve this
for inM=1:nInMaps
    for outM=1:nOutMaps
        w{outM,inM}=rot90(w{outM,inM},2);
    end
end


%% Arg defaults
if nargin<3 || isempty(Y), %initialise prediction neuron outputs to zero
    for outM=1:nOutMaps
        Y{outM}=zeros(a-c+1,b-d+1,'single');
    end
end
out_map_size = size(Y{1}(:,:,1));
avoidEdgeEffects=1;
if avoidEdgeEffects
  %pad image (and all other image-sized arrays) to avoid edge effects
  for j=1:nInMaps
    X{j} = pad_with_fade(X{j},[c,d]);
%     X{j}=padarray(X{j},[c,d],'replicate');%'symmetric');
%     fade=[1:c]./c;
%     X{j}(1:c,:)=X{j}(1:c,:).*repmat(fade',1,b+2*d);
%     X{j}(a+c+[1:c],:)=X{j}(a+c+[1:c],:).*repmat(flipud(fade'),1,b+2*d);
%     fade=[1:d]./d;
%     X{j}(:,1:d)=X{j}(:,1:d).*repmat(fade,a+2*c,1);
%     X{j}(:,b+d+[1:d])=X{j}(:,b+d+[1:d]).*repmat(fliplr(fade),a+2*c,1); 
  end
  for i=1:nOutMaps
    Y{i}=padarray(Y{i},[c,d],'replicate');%'symmetric');
  end
end
if nargin<4 || isempty(iterations), iterations=50; end

if nargin<5 || isempty(v)
    %set feedback weights equal to feedforward weights normalized by maximum value
    for outM=1:nOutMaps
        %calc normalisation values by taking into account all weights contributing to
        %each RF type
        
        maxVal=0;
        for inM=1:nInMaps
            if ~isempty(w{outM,inM})
                maxVal=max(maxVal,max(max(abs(w{outM,inM}))));
            end
        end
        
        %apply normalisation to calculate feedback weight values.
        for inM=1:nInMaps
            v{outM,inM}=w{outM,inM};
            %v{outM,inM}=abs(w{outM,inM})./max(1e-6,maxVal);
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

%% Try to speed things up
if exist('convnfft')==2 && min(c,d)>15 && min(a,b)>15
    conv_fft=1;%use fft version of convolution for large images and/or
    %masks. see:
    %www.mathworks.com/matlabcentral/fileexchange/24504-fft-based-convolution
else
    conv_fft=0;%use standard MATLAB conv2 function for smaller images and/or masks,
    %or if faster function is not installed
end


%% Rotate w masks

%FF weights are rotated so that convolution can be used to apply the filtering
%(otherwise the mask gets rotated every iteration!)
for inM=1:nInMaps
    for outM=1:nOutMaps
        w{outM,inM}=rot90(w{outM,inM},2);
    end
end

% %% For simplicity, do the splitting after all  scalling of w,v
% isInputSplitted=zeros(nInMaps);
% isMaskSplitted=zeros(nOutMaps,nInMaps);
% Xneg=cell(inM,1);
% for inM=1:nInMaps
%     for outM=1:nOutMaps
%         [w{outM,inM},isSp]=SplitMatrix(w{outM,inM});
%         isInputSplitted(inM) = isInputSplitted(inM) || isSp;
%         isMaskSplitted(outM,inM)=true;
%
%         v{outM,inM}=SplitMatrix(v{outM,inM});
%     end
%     if isInputSplitted(inM)
%         Xneg{inM}=max(X{inM}(:))-X{inM};
%         Xneg{inM}=-X{inM};
%         Xneg{inM}=X{inM};
%     end
% end
%% ////////////////////Main Loop/////////////////////////////////////

%iterate DIM equations to determine neural responses
%fprintf(1,'dim_conv(%i): ',conv_fft);
R=cell(nInMaps,1);
E=cell(nInMaps,1);
for t=1:iterations
    %fprintf(1,'.%i.',t);
    %update error-detecting neuron responses
    for inM=1:nInMaps
        %calc predictive reconstruction of the input maps
        R{inM}=single(0);%reset reconstruction of input
        for outM=1:nOutMaps
            %sum reconstruction over each output map
            R{inM}=R{inM,1}+conv2(Y{outM},v{outM,inM},'full');
        end
        %calc error between reconstruction and actual input: using values of input
        %that change over time (if these are provided)
        %E{j}=tanh(X{j}(:,:,min(t,size(X{j},3))))./max(epsilon2,R{j});
        %E{inM}=X{inM}./max(epsilon2,R{inM,1});
        E{inM} = err_calc(X{inM},R{inM});
        
        if nargout>4
            Etrace{inM}(:,:,t)=E{inM};%record response over time
        end
        if nargout>5
            Rtrace{inM}(:,:,t)=R{inM};%record response over time
        end
    end
    %update prediction neuron responses
    for outM=1:nOutMaps
        dY=single(0);
        %sum inputs to prediction neurons from each input map
        for inM=1:nInMaps
            %input=input+max(0,conv2(E{j},w{i,j},'same')); %sensitive to phase
            %input=input+abs(conv2(E{j},w{i,j},'same')); %invariant to phase
            dY=dY+conv2(E{inM},w{outM,inM},'valid');
        end
        %dY=(dY-1).*0.1 + 1;
        %dY=(sigm(dY)*2).^2;
        %modulate prediction neuron response by current input:
        %Y{outM}=max(epsilon1,Y{outM}).*dY;
        Y{outM} = out_upd(max(epsilon1,Y{outM}),dY);
        %Y{outM}=ReLU(Y{outM});
        if nargout>3
            Ytrace{outM}(:,:,t)=Y{outM};%record response over time
        end
    end
    %     a1_R=R{1};
    %     a2_E1=E{1};
    %     a3_Input=dY;
    %     a4_Y1=Y{1};
    
%     PlotAsImages({R{1,1},E{1,1};dY,Y{1}}, ...
%         {'R','E';'dY','Y'})
%     PlotAsHistograms({R{1,1},E{1,1};dY,Y{1}}, ...
%         {'R','E';'dY','Y'})
    %     PlotAsImagesAndHist({R{1,1},R{1,2};E{1,1},E{1,2};dY,Y{1}}, ...
    %         {'Rpos','Rneg';'Epos','Eneg';'dY','Y'})
    %pause(0.1)
    %waitforbuttonpress
end
if avoidEdgeEffects
  %return results that are the same size as original (unpadded) image
  for j=1:nInMaps
    if ~iszero(R{j}) %skip empty channels
      temp = unpad(R{j},[a,b],[c,d]);
      R{j}=R{j}(c+[1:a],d+[1:b]);

      E{j}=E{j}(c+[1:a],d+[1:b]);
    end
  end
  for i=1:nOutMaps
    Y{i}=unpad(Y{i},out_map_size,[c,d]);
  end
end
end
function conv=ConvOrFFT(A,B,shape,conv_fft)
if conv_fft==1
    conv=convnfft(A,B,shape);
else
    conv=convn(A,B,shape);
end
end

function E = err_calc(X,R)
    E = cust_sigm(X-R);%./cust_sigm(R);
%     E = X./scaled(R,     0.0000001);
%     E = X./logloss(R);
    %E = X;
end
function Ynew = out_upd(Y, dY)
    dY=(dY-1).*0.1 + 1;
    Ynew = cust_sigm(Y+dY);%.* cust_sigm(dY);
    Ynew = Y.* scaled(dY,0.0000001);
    Ynew = Y.*logloss(dY);
end

function y = scaled(x, minval)
    y = x - min(x(:)); %first make positive
    y  = y / max(mean(y(:)), 1) + minval;
end

function s = cust_sigm(x)
    s= 1./(1+exp(-x))*2;
end

function y= logloss(x)
    %log1p(x)=log(1+x), more accurate
    scale=1;
    y = log1p(exp(x))/log1p(2);
end




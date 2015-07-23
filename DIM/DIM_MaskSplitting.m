function [Y,E,R,Ytrace,Etrace,Rtrace]=DIM_MaskSplitting...
    (w,X,Y,iterations,v,downsample)
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
epsilon2=1e-3;

disp('dim_activation_conv_recurrent');
disp(['  epsilon1=',num2str(epsilon1),' epsilon2=',num2str(epsilon2)]);

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
        Y{outM}=zeros(a,b,'single');
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

%% For simplicity, do the splitting after all  scalling of w,v
isInputSplitted=zeros(nInMaps);
isMaskSplitted=zeros(nOutMaps,nInMaps);
Xneg=cell(inM,1);
for inM=1:nInMaps
    for outM=1:nOutMaps
        [w{outM,inM},isSp]=SplitMatrix(w{outM,inM});
        isInputSplitted(inM) = isInputSplitted(inM) || isSp;
        isMaskSplitted(outM,inM)=true;
        
        v{outM,inM}=SplitMatrix(v{outM,inM});
    end
    if isInputSplitted(inM)
        Xneg{inM}=max(X{inM}(:))-X{inM};
        Xneg{inM}=-X{inM};
        Xneg{inM}=X{inM};
    end
end
%% ////////////////////Main Loop/////////////////////////////////////

%iterate DIM equations to determine neural responses
fprintf(1,'dim_conv(%i): ',conv_fft);
R=cell(nInMaps,2);
E=cell(nInMaps,2);
for t=1:iterations
    fprintf(1,'.%i.',t);
    %update error-detecting neuron responses
    for inM=1:nInMaps
        %calc predictive reconstruction of the input maps
        R{inM,1}=single(0);%reset reconstruction of input
        if isInputSplitted(inM)
            R{inM,2}=single(0);%reset reconstruction of input
        end
        for outM=1:nOutMaps            
            %sum reconstruction over each output map
            if isMaskSplitted(outM,inM)
                R{inM,1}=R{inM,1}+ConvOrFFT(Y{outM},v{outM,inM}{1},'same',conv_fft);
                R{inM,2}=R{inM,2}+ConvOrFFT(Y{outM},v{outM,inM}{2},'same',conv_fft);
            else
                R{inM,1}=R{inM,1}+ConvOrFFT(Y{outM},v{outM,inM},'same',conv_fft);
            end
        end
        %calc error between reconstruction and actual input: using values of input
        %that change over time (if these are provided)
        %E{j}=tanh(X{j}(:,:,min(t,size(X{j},3))))./max(epsilon2,R{j});
        E{inM,1}=X{inM}./max(epsilon2,R{inM,1});
        if isInputSplitted(inM)
            E{inM,2}=Xneg{inM}./max(epsilon2,R{inM,2});  
        end
        
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
            if isMaskSplitted(outM,inM)
                dY=dY+ConvOrFFT(E{inM,1},w{outM,inM}{1},'same',conv_fft);
                dY=dY-ConvOrFFT(E{inM,2},w{outM,inM}{2},'same',conv_fft);
                %dY=-dY;
            else
                dY=dY+ConvOrFFT(E{inM,1},w{outM,inM},'same',conv_fft);
            end            
        end
        %dY=(dY-1).*0.1 + 1;
        dY=(sigm(dY)*2).^2;
        %modulate prediction neuron response by current input:
        Y{outM}=max(epsilon1,Y{outM}).*dY;
        %Y{outM}=ReLU(Y{outM});
        if nargout>3
            Ytrace{outM}(:,:,t)=Y{outM};%record response over time
        end
    end
%     a1_R=R{1};
%     a2_E1=E{1};
%     a4_Y1=Y{1};
%     a3_Input=input;
    PlotAsImages({R{1,1},R{1,2};E{1,1},E{1,2};E{1,1}-E{1,2},dY;Y{1},[]}, ...
        {'Rpos','Rneg';'Epos','Eneg';'E','dY';'Y',[]})
    PlotAsHistograms({R{1,1},R{1,2};E{1,1},E{1,2};E{1,1}-E{1,2},dY;Y{1},[]}, ...
        {'Rpos','Rneg';'Epos','Eneg';'E','dY';'Y',[]})
%     PlotAsImagesAndHist({R{1,1},R{1,2};E{1,1},E{1,2};dY,Y{1}}, ...
%         {'Rpos','Rneg';'Epos','Eneg';'dY','Y'})
    %pause(0.1)
    waitforbuttonpress

    
end
disp(' ');
end

function conv=ConvOrFFT(A,B,shape,conv_fft)
    if conv_fft==1
        conv=convnfft(A,B,shape);
    else
        conv=conv2(A,B,shape);
    end
end





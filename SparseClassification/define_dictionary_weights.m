function [W,V,classDict]=define_dictionary_weights(data,class)
[m,numPatterns]=size(data);
numClasses=max(class);
GP=global_parameters;

switch GP.dictionary
  case 'all'
    %DEFINE THE DICTIONARY
    %use all data in the training set as elements of the dictionary
    V=data';
    W=define_pcbc_feedforward_weights(V);
    %RECORD THE CLASS OF EACH DICTIONARY ELEMENT
    classDict=class;

  case 'constructive'
    %DEFINE THE DICTIONARY
    %start with a single basis vector for each class...
    for c=1:numClasses
      ind=find(class==c); V(c,:)=data(:,ind(1))';%the 1st exemplar
      %V(c,:)=mean(data(:,class==c)');%the prototype for the class
      classDict(c)=c;
    end
    V=norm_dictionary(V);
    W=define_pcbc_feedforward_weights(V); 
    D=define_decoding_weights(W,V,classDict,data,class);
    %...then for each pattern in the test set, if it is not correctly classified
    %using the current dictionary, add it to the dictionary
    [n,m]=size(V);
    converged=0;
    k=0;
    while ~converged
      fprintf(1,'adding dictionary entries: ');
      k=k+1;
      nold=n;
      for pattern=1:numPatterns
        if rem(pattern,500)==0, fprintf(1,'.%i/%i.',pattern,numPatterns); end
        x=data(:,pattern);
        [y,e,s,nmse]=calc_sparse_representation(W,V,x,classDict,0);
        switch GP.network
          case 'subnets'
            %classify based on which sub-dictionary has lowest reconstruction error
            [val,classGenerated]=min(nmse);
          case 'single'
            z=D*y;
            [val,classGenerated]=max(z);
        end
        classExpected=class(pattern);
        if classExpected~=classGenerated,
          n=n+1;
          V(n,:)=x';
          W=define_pcbc_feedforward_weights(V); 
          classDict(n)=classExpected;    
          D=define_decoding_weights(W,V,classDict,data,class);
        end
      end
      [nnew,m]=size(V);
      nnew
      if nnew==nold || k>10, converged=1; end
    end
  
  case 'selective'
    %DEFINE THE DICTIONARY 
    %start with a dictionary containing all elements of the training set...
    V=data';
    %... then use the normalised cross-correlation to measure the similarity of
    %dictionary elements...
    Vnorm=norm_dictionary(V,2);
    NCC=Vnorm*Vnorm';
    indDelete=[];
    Vnew=[];
    classNew=[];
    [n,m]=size(V);
    for j=1:n
      if sum(ismember(indDelete,j))>0
        %skip - already due for deletion
      else
        %...if multiple dictionary elements are similar and of the same class delete
        %them and add a new element (with the same class label) that is the mean
        %of the similar elements
        indSimilarAndSameClass=NCC(j,:)>0.975 & class==class(j);
        if sum(indSimilarAndSameClass)>1
          indDelete=[indDelete,find(indSimilarAndSameClass==1)];
          Vnew=[Vnew;mean(V(indSimilarAndSameClass,:))];
          classNew=[classNew,class(j)];
        end
      end
    end
    %reorganise dictionary, deleting similar elements and adding new (merged) elements
    indKeep=ones(n,1);
    indKeep(indDelete)=0;
    indKeep=logical(indKeep);
    classDict=class(indKeep);
    classDict=[classDict,classNew];
    V=V(indKeep,:);
    V=[V;Vnew];
    W=define_pcbc_feedforward_weights(V);
    
  case 'learn'
    cycs=10000
    nodesPerClass=100
    [W,V]=weight_initialisation_random(nodesPerClass*numClasses,m);
    classDict=[];    
    for c=1:numClasses
      %define class of each dictionary element: this is only accurate if using 'subnets'. If using a 'single' dictionary, decoding methods that use classDict (i.e. errMax and errErr) will produce random results.
      classDict=[classDict,ones(1,nodesPerClass)*c];
    end
    fprintf(1,'learning dictionary entries: ');
    for k=1:cycs
      if rem(k,100)==0, fprintf(1,'.%i.',k); end
      %select training data
      patternNum=fix(rand*numPatterns)+1; %random order
      x=data(:,patternNum);
      %calculate network response and update weights
      [y,e]=calc_sparse_representation(W,V,x,classDict,0);
      switch GP.network
        case 'subnets'
          %only update elements in one sub-dictionary
          c=class(patternNum);
          y(classDict~=c)=0; 
          e=e(:,c);
      end 
      %c=class(patternNum);
      %y(classDict~=c)=0; 
      [W,V]=dim_learn(W,V,y,e,0.05);
    end
    figure(3),clf
    k=0;
    for c=1:numClasses
      for j=1:nodesPerClass
        k=k+1;
        maxsubplot(numClasses,nodesPerClass,k),
        plot_weights(V(k,:));
      end
    end
    drawnow;
    
  otherwise
    disp('ERROR: no method specified for creating dictionary');
end

disp(' ');
[n,m]=size(V);
disp(['dictionary has ',num2str(n),' elements of length ',num2str(m)]);


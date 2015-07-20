function GP=global_parameters()
GP.dictionary='all';
GP.network='single';%'subnets';%
GP.decode='binary';
GP.alg='PCBC';
GP.iterations=100;
GP.data_set='USPS';GP.imDims=[16,16];
%GP.data_set='ISOLET';GP.imDims=[1,617];
%GP.data_set='MNIST';GP.imDims=[28,28];
%GP.data_set='NORB';GP.imDims=[96,96];
%GP.data_set='CIFAR10';GP.imDims=[32,32];
%GP.data_set='ARTIF';GP.imDims=[11,11];
GP.onoff=0;
GP.neg=0;
GP.dict_norm=Inf;

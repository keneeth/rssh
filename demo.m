clear;clc;

db_name = 'USPSdata.mat';
data = construct_data(db_name);

%% parmeters
sigma = 0.4;
r = 100;
beta = 1e-1;
lambda = 10;
eta = 1e-3;
bits = 32;
%% kernel computing
data.train_data_kernel = normr(data.train_data);
data.test_data_kernel = normr(data.test_data);
% get anchors
Ntrain = size(data.train_data,1);
Ntest = size(data.test_data,1);
n_anchors = min(Ntrain,2000);
rand('seed',0);
anchor = data.train_data_kernel(randsample(Ntrain, n_anchors),:);
Phi_testdata = exp(-sqdist(data.test_data_kernel,anchor)/(2*sigma*sigma));
Phi_testdata = [Phi_testdata, ones(Ntest,1)];
Phi_traindata = exp(-sqdist(data.train_data_kernel,anchor)/(2*sigma*sigma));
Phi_traindata = [Phi_traindata, ones(Ntrain,1)];
data.train_data_kernel = Phi_traindata;
data.test_data_kernel = Phi_testdata;

%% compute U,V
[U,V] = MF((data.train_data)',r);
params.U = U;
params.V = V;

params.b = bits;
params.beta = beta;
params.eta = eta;
params.lambda = lambda;
params.epchos = 5;
[n,d] = size(data.train_data_kernel);
% Initialization
randn('seed',0);
params.G = randn(n,params.b);
params.A = params.G;
params.B = sgn(params.G);

params.train_data = data.train_data_kernel;
params.test_data = data.test_data_kernel;
params.train_label = data.train_label;
params.test_label = data.test_label;

params = solve(params);

[MAP] = cal_map(params);
fprintf('beta:%g, lambda:%g, eta:%g, bit:%f, r:%d, MAP:%f\n',...
    beta,lambda,eta,bits,r,MAP);
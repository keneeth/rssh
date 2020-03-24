function exp_data = construct_data(db_name)

% construct data
fprintf('starting construct %s database\n\n', db_name);

% split data to trainging and test
if strcmp(db_name,'USPSdata.mat')
    load ./datasets/USPSdata.mat;
    db_data = USPSdata(:,1:256);
    label = USPSdata(:,257);
    db_lable = zeros(size(db_data,1),10);
    for i=1:length(db_data)
        db_label(i,label(i)) = 1;
    end
    exp_data.k = 10;
    clear USPSdata;
end

% split test data
[n,d] = size(db_data);
rand('seed',0);
rowrank = randperm(n);
% num_test = min(floor(n*0.1),1000);
num_test = 1000;
num_training = n-num_test;
test_data = db_data(rowrank(1:num_test),:);
test_label = db_label(rowrank(1:num_test),:);
rowrank(1:num_test) = [];
train_data = db_data(rowrank,:);
train_label = db_label(rowrank,:);

if size(train_label,2)==1
    train_label = train_label';
end
if size(test_label,2)==1
    test_label = test_label';
end

% WtrueTestTraining:the similarity matrix of training data and test data(0 or 1)
WtrueTestTraining = (test_label*train_label')>0;

% center the data, VERY IMPORTANT
biaozhunhua = 0;
XX = [train_data; test_data];
XX = double(XX);
if biaozhunhua
    sampleMean = mean(XX,1);
    sampleStd = std(XX,1);
    XX = (double(XX)-repmat(sampleMean,size(XX,1),1))./repmat(sampleStd,size(XX,1),1);
end
exp_data.train_data = XX(1:num_training, :);
exp_data.test_data = XX(num_training+1:end, :);
exp_data.db_data = XX;
exp_data.train_label = train_label;
exp_data.test_label = test_label;
exp_data.WTT = WtrueTestTraining;
exp_data.train_data = train_data;

fprintf('constructing %s database has finished\n\n', db_name);

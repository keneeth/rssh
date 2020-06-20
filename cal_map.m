function [pre] = cal_map(params)
B_trn = params.B;
num_train = size(B_trn,1);
B_trn(B_trn<0) = 0;
B_trn = compactbit(B_trn);
B_tst = hash_method(params.W,params.test_data);
Dhamm = hammingDist(B_tst, B_trn);

[~, HammingRank]=sort((Dhamm'),1);
numtest = size(HammingRank,2);
for i = 1 : numtest
    y = HammingRank(:,i);
    x=0;
    p=0;
    new_label = params.train_label * params.test_label(i,:)';
    new_label(new_label>0) = 1;
    
    num_return_NN = num_train;
    for j=1:num_return_NN
        if new_label(y(j))>0
            x=x+1;
            p=p+x/j;
        end
    end  
    if p==0
        apall(i)=0;
    else
        apall(i)=p/x;
    end
end
pre = sum(apall)/numtest;
end


clc
clear
close all

%% LOAD DATA
x = readtable('amazon.csv');

dp = str2double(erase(string(x.("discounted_price")), {'₹',','}));
ap = str2double(erase(string(x.("actual_price")), {'₹',','}));
disc = str2double(erase(string(x.("discount_percentage")), {'%'}));
rate = str2double(string(x.("rating")));
rc = str2double(erase(string(x.("rating_count")), {','}));

data = [dp ap disc rate rc];
data(any(isnan(data),2),:) = [];

Y = round(data(:,4));
X = data(:,[1 2 3 5]);

%% NORMALIZE
X = (X - mean(X)) ./ std(X);

%% PCA
C = cov(X);
[V, D] = eig(C);
[~, idx] = sort(diag(D),'descend');
V = V(:,idx);
pc = X * V(:,1:2);

% CENTER PCA
pc = pc - mean(pc);

%% SPLIT
n = length(Y);
idx_rand = randperm(n);
train_n = round(0.7*n);

train_idx = idx_rand(1:train_n);
test_idx = idx_rand(train_n+1:end);

Xtrain = pc(train_idx,:);
Ytrain = Y(train_idx);
Xtest = pc(test_idx,:);
Ytest = Y(test_idx);

%% ==============================
%% SVM (NO GROUPING)
%% ==============================
Ytrain_svm = Ytrain;
Ytrain_svm(Ytrain >= 4) = 1;
Ytrain_svm(Ytrain < 4) = -1;

Ytest_svm = Ytest;
Ytest_svm(Ytest >= 4) = 1;
Ytest_svm(Ytest < 4) = -1;

[m,d] = size(Xtrain);
w = zeros(d,1); b = 0;
lr = 0.001; lambda = 0.01;

for e = 1:100
    for i = 1:m
        if Ytrain_svm(i)*(Xtrain(i,:)*w + b) < 1
            w = w + lr*(Ytrain_svm(i)*Xtrain(i,:)' - 2*lambda*w);
            b = b + lr*Ytrain_svm(i);
        else
            w = w + lr*(-2*lambda*w);
        end
    end
end

pred_svm1 = sign(Xtest*w + b);
acc_svm1 = sum(pred_svm1 == Ytest_svm)/length(Ytest_svm)*100;

%% ==============================
%% K-MEANS (NO GROUPING)
%% ==============================
k = 5;
centroids1 = pc(randperm(n,k),:);

for iter = 1:50
    for i = 1:n
        d = sum((centroids1 - pc(i,:)).^2,2);
        [~, cidx] = min(d);
        cluster1(i) = cidx;
    end
    for j = 1:k
        centroids1(j,:) = mean(pc(cluster1==j,:),1);
    end
end

% Accuracy for K-means (No Grouping)
cluster_label = zeros(k,1);
for j = 1:k
    idxs = find(cluster1 == j);
    if ~isempty(idxs)
        cluster_label(j) = mode(Y(idxs));
    end
end

pred_kmeans1 = zeros(n,1);
for i = 1:n
    pred_kmeans1(i) = cluster_label(cluster1(i));
end

acc_kmeans1 = sum(pred_kmeans1 == Y)/n * 100;

%% ==============================
%% GROUPING
%% ==============================
Yg = Y;
Yg(Y <= 2) = 1;
Yg(Y == 3) = 2;
Yg(Y >= 4) = 3;

Xg = [X cluster1'];

%% PCA AGAIN
C2 = cov(Xg);
[V2, D2] = eig(C2);
[~, idx2] = sort(diag(D2),'descend');
V2 = V2(:,idx2);
pc2 = Xg * V2(:,1:2);

% CENTER PCA
pc2 = pc2 - mean(pc2);

Xtrain2 = pc2(train_idx,:);
Xtest2 = pc2(test_idx,:);
Ytrain2 = Yg(train_idx);
Ytest2 = Yg(test_idx);

%% ==============================
%% SVM (GROUPING)
%% ==============================
Ytrain2(Ytrain2 >= 2) = 1;
Ytrain2(Ytrain2 < 2) = -1;

Ytest2(Ytest2 >= 2) = 1;
Ytest2(Ytest2 < 2) = -1;

[m,d] = size(Xtrain2);
w2 = zeros(d,1); b2 = 0;

for e = 1:100
    for i = 1:m
        if Ytrain2(i)*(Xtrain2(i,:)*w2 + b2) < 1
            w2 = w2 + lr*(Ytrain2(i)*Xtrain2(i,:)' - 2*lambda*w2);
            b2 = b2 + lr*Ytrain2(i);
        else
            w2 = w2 + lr*(-2*lambda*w2);
        end
    end
end

pred_svm2 = sign(Xtest2*w2 + b2);
acc_svm2 = sum(pred_svm2 == Ytest2)/length(Ytest2)*100;

%% ==============================
%% K-MEANS (GROUPING)
%% ==============================
k2 = 3;
centroids2 = pc2(randperm(n,k2),:);

for iter = 1:50
    for i = 1:n
        d = sum((centroids2 - pc2(i,:)).^2,2);
        [~, cidx] = min(d);
        cluster2(i) = cidx;
    end
    for j = 1:k2
        centroids2(j,:) = mean(pc2(cluster2==j,:),1);
    end
end

% Accuracy for K-means (Grouped)
cluster_label2 = zeros(k2,1);
for j = 1:k2
    idxs = find(cluster2 == j);
    if ~isempty(idxs)
        cluster_label2(j) = mode(Yg(idxs));
    end
end

pred_kmeans2 = zeros(n,1);
for i = 1:n
    pred_kmeans2(i) = cluster_label2(cluster2(i));
end

acc_kmeans2 = sum(pred_kmeans2 == Yg)/n * 100;

%% ==============================
%% PLOTS
%% ==============================
figure;

subplot(2,3,1)
scatter(pc(:,1), pc(:,2), 15, Y, 'filled')
title('PCA (Original)'); grid on

subplot(2,3,2)
gscatter(pc(:,1), pc(:,2), cluster1)
title('K-means (No Grouping)'); grid on

subplot(2,3,3)
gscatter(Xtest(:,1), Xtest(:,2), Ytest_svm); hold on
x1 = linspace(-3,3,100);
plot(x1, -(w(1)*x1 + b)/w(2), 'k','LineWidth',2)
xlim([-3 3]); ylim([-3 3])
title('SVM (No Grouping)'); grid on

subplot(2,3,4)
scatter(pc2(:,1), pc2(:,2), 15, Yg, 'filled')
title('PCA (Grouped)'); grid on

subplot(2,3,5)
gscatter(pc2(:,1), pc2(:,2), cluster2)
title('K-means (Grouped)'); grid on

subplot(2,3,6)
gscatter(Xtest2(:,1), Xtest2(:,2), Ytest2); hold on
x1 = linspace(-3,3,100);
plot(x1, -(w2(1)*x1 + b2)/w2(2), 'k','LineWidth',2)
xlim([-3 3]); ylim([-3 3])
title('SVM (Grouped)'); grid on

%% ==============================
%% OUTPUT
%% ==============================
fprintf('\n===== FINAL RESULTS =====\n');
fprintf('SVM (No Grouping): %.2f%%\n', acc_svm1);
fprintf('SVM (With Grouping): %.2f%%\n', acc_svm2);
fprintf('K-Means (No Grouping): %.2f%%\n', acc_kmeans1);
fprintf('K-Means (With Grouping): %.2f%%\n', acc_kmeans2);
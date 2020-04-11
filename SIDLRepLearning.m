function [ZRep,learn_time,fit_time] = SIDLRepLearning(dataset_name, DS, K, lambda, r)  
% dataset_name is dataset name
% DS is the dataset structure
% K is number of coefficients [10, 20, 50]
% lambda is the regularizer [0.1, 1, 10]
% r is length of time series [0.1, 0.25, 0.5]


rng(1);

train_X = DS.Train;
test_X  = DS.Test;

train_y = DS.TrainClassLabels;
test_y  = DS.TestClassLabels;

[n_train, p] = size(train_X);
[n_test, p] = size(test_X);

c = 100;
epsilon = 1e-3;
maxIter = 10;
maxInnerIter = 3;

%epsilon = 1e-3;
%maxIter = 50;
%maxInnerIter = 5;


    A_rand_init = randn(n_test, K);

      q = ceil(p*r);
      % run id 
      runid = strcat(dataset_name, '_l_', num2str(lambda), '_K_', num2str(K), '_q_', num2str(q));

      % train SIDL on training set
      tic;
      [S, A, Offsets] = USIDL(train_X, train_y, lambda, K, q, c, epsilon, maxIter, maxInnerIter, runid);

      learn_time = toc;
      %fprintf('\n##### TRAINING TIME on TRAIN SET (K=%f, lambda=%f, r=%f): %f secs.\n\n', K, lambda, r, learn_time);

      % learn sparse coding on test set with dictionary learned from training set
      A_test = A_rand_init;
      Offsets_test = randi([0, p-q], n_test, K);
      tic;
      [A_test, Offsets_test, F_all] = update_A_par(test_X, S, A_test, Offsets_test, lambda, maxIter, epsilon);
      fit_time = toc;
      
      % get reconstruciton for SIDL
      test_recons_error_sidl = unsup_obj(test_X, S, A_test, Offsets_test, 0) / n_test;
      
      %fprintf('\n\n##### RECONS ERROR on TEST SET (K=%f, lambda=%f) SIDL (r=%f): %f\n\n', K, lambda, r, test_recons_error_sidl);

    

ZRep = [A;A_test];
  
  
end


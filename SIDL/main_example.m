%{
The MIT License (MIT)
Copyright (c) 2016 Guoqing Zheng

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies of the Software, including modified versions of the software,
and substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
%}

rng(1);

dataset_name = 'Trace';

train_file = strcat(dataset_name, '_TRAIN');
test_file  = strcat(dataset_name, '_TEST');

train_data = load(train_file);
test_data = load(test_file);


train_X = train_data(:, [2:end]);
test_X  = test_data(:, [2:end]);

train_y = train_data(:, 1);
test_y  = test_data(:, 1);

[n_train, p] = size(train_X);
[n_test, p] = size(test_X);

c = 100;
epsilon = 1e-5;
maxIter = 1e3;
maxInnerIter = 5;

% loop through a set of variables
Ks = [20];%, 20, 50, 100];  
lambdas = [1];%0.1, 1, 10, 100];
rs = [0.25];%, 0.5, 0.25]; 

for K = Ks
  for lambda = lambdas
    A_rand_init = randn(n_test, K);
    for r = rs
      q = ceil(p*r);
      % run id 
      runid = strcat(dataset_name, '_l_', num2str(lambda), '_K_', num2str(K), '_q_', num2str(q));

      % train SIDL on training set
      tic;
      [S, A, Offsets] = USIDL(train_X, train_y, lambda, K, q, c, epsilon, maxIter, maxInnerIter, runid);

      learn_time = toc;
      fprintf('\n##### TRAINING TIME on TRAIN SET (K=%f, lambda=%f, r=%f): %f secs.\n\n', K, lambda, r, learn_time);

      % learn sparse coding on test set with dictionary learned from training set
      A_test = A_rand_init;
      Offsets_test = randi([0, p-q], n_test, K);
      tic;
      [A_test, Offsets_test, F_all] = update_A_par(test_X, S, A_test, Offsets_test, lambda, maxIter, epsilon);
      fit_time = toc;
      
      % get reconstruciton for SIDL
      test_recons_error_sidl = unsup_obj(test_X, S, A_test, Offsets_test, 0) / n_test;
      
      fprintf('\n\n##### RECONS ERROR on TEST SET (K=%f, lambda=%f) SIDL (r=%f): %f\n\n', K, lambda, r, test_recons_error_sidl);

      save(runid);
    end
  end
end


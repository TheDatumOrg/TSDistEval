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

function [S, A, Offsets, F_obj] = USIDL(X, y, lambda, K, q, c, epsilon, maxIter, maxInnerIter, runid)
% function [S, A, Offsets, F_obj] = USIDL(X, y, lambda, K, q, c, epsilon, maxIter, maxInnerIter)
%
% X: n x p, training data, n times series with length p
% y: binary label (-1, 1), not used in this model, just for plotting
% lambda: regularization parameter for l1 norm
% K: number of basis
% q: length of basis over
% c: Squared L2-norm of basis, i.e., ||s_k||^2 <= c
% epsilon: epsilon
% maxIter: maximum outter iterations
% maxInnerIter: maximum inner iterations
% runid: magic string prefix for plotting  
%
% Returns: S: learned basis
%          A: coefficients for training data
%          Offsets: matched location of the basis
%          F_obj: array of objective values
  
  [n,p] = size(X);

  S = randn(K, q);                 % initialize bases
  A = randn(n, K);                 % basis initializations
  Offsets = randi([0, p-q], n, K);      % initialize offsets
  
  F_obj = [];
  
  for iter =1:maxIter
    % update coefficients and matching offsets
    [A, Offsets] = update_A_par(X, S, A, Offsets, lambda, maxInnerIter, epsilon);
    
    % update bases
    S = update_S(X, S, A, Offsets, lambda, c, maxInnerIter, epsilon);
    
    % check convergence
    F_all = unsup_obj(X, S, A, Offsets, lambda);

    F_obj(end+1) = F_all;
    if length(F_obj) > 1 & abs(F_obj(end) - F_obj(end-1)) / F_obj(end-1) < epsilon
      fprintf('Converged!\n');
      return
    end
    
  end
  fprintf('Maximum Iteration Reached!\n');
end

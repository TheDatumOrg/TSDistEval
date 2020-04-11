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

function [A, Offsets, F_all] = update_A_par(X, S, A, Offsets, lambda, maxIter, epsilon)
% X: n x p
% S: K x q
% A: n x K
% Offsets: n x K
  
  [n,p] = size(X);
  [KK,q] = size(S);
  seg_idx = bsxfun(@plus, repmat([1:q], p-q+1, 1), [0:p-q]');

  F_obj = [];
  for iter = 1:maxIter
    for i=1:n % compute activation and matching offset for X_i
      x = X(i,:);
      offs = Offsets(i,:);
      shifted_S = op_shift(S, offs, p);

      %for k=1:KK % compute for base k % RAND PERM DOESN'T HURT
      for k=randperm(KK) % compute for base k % RAND PERM DOESN'T HURT
        base = S(k,:);
        temp_a = A(i,:);
        temp_a(k) = 0; % exclude alpha_k
        
        x_residue = x - temp_a * shifted_S;
        residue_norm2 = norm(x_residue)^2;
        base_norm2 = norm(base)^2; %||s_k||^2

        segs = x_residue(seg_idx);
        dot_prods = segs * base';

        [M_dp, M_idx] = max(abs(dot_prods));

        if M_dp <= lambda
          a_k_star = 0;
        else
          a_k_star = sign(dot_prods(M_idx)) * (M_dp - lambda) / base_norm2;
          t_k_star = M_idx -1;
        end

        A(i, k) = a_k_star;
        if a_k_star ~= 0
%          shifted_base = op_shift(base, t_k_star, p);
          shifted_S(k,:) = 0;
          shifted_S(k, [t_k_star + 1: t_k_star + q]) = base;
%          shifted_S(k,:) = shifted_base;
          Offsets(i, k) = t_k_star;
        end
      end
      
    end

    F_all = unsup_obj(X, S, A, Offsets, lambda);
    %fprintf('Current F_all: %f\n', F_all);
    F_obj(end+1) = F_all;
    if length(F_obj) > 1 & abs(F_obj(end) - F_obj(end-1)) / F_obj(end-1) < epsilon
      %fprintf('Updating A: Converged!\n\n');
      return
    end

  end

  %fprintf('Updating A: Reached max iter.\n\n');
end


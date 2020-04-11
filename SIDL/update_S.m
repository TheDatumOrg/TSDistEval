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

function S = update_S(X, S, A, Offsets, lambda, c, maxIter, epsilon)
% X: n x p
% S: K x q
% A: n x K
% Offsets: n x K

  [n, p] = size(X);

  [K, q] = size(S);


  F_obj = [];

  for iter = 1:maxIter
    for k=1:K % optimize s_k
      M_k = norm(A(:,k))^2;
      if M_k == 0 % inactive bases, no need to update
        continue
      end

      s_k = 0;

      for i=1:n
        temp_a = A(i,:);
        temp_a(k) = 0;
        shifted_S = op_shift(S, Offsets(i,:), p);
        xi_residue = X(i,:) - temp_a * shifted_S;

        t_ik = Offsets(i,k);
        s_k = s_k + A(i,k) * xi_residue(1+t_ik:q+t_ik);
      end

      % compute s_k
      
      if M_k <= norm(s_k) / sqrt(c)
        s_k = sqrt(c) / norm(s_k) * s_k;
      else
        s_k = s_k / M_k;
      end
    
      S(k,:) = s_k;

    end

    F_all = unsup_obj(X, S, A, Offsets, lambda);
    %fprintf('Current F_all: %f\n', F_all);
    F_obj(end+1) = F_all;
    if length(F_obj) > 1 & abs(F_obj(end) - F_obj(end-1)) / F_obj(end-1) < epsilon
      %fprintf('Updating S: Converged!\n\n');
      return
    end
  end

  
  %fprintf('Updating S: Reached max iter.\n\n');
end

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

function F = unsup_obj(X, S, A, Offsets, lambda)
% X: n x p
% S: K x q
% A: n x K
% Offsets: n x K

  [n, p] = size(X);
  [K, q] = size(S);

  F = 0;

  for i=1:n
    x = X(i,:);
    shifted_S = op_shift(S, Offsets(i,:), p);
    F = F + 0.5 * norm(x - A(i,:) * shifted_S)^2 + lambda * norm(A(i,:), 1);

  end

end

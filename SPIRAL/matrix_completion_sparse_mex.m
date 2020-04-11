function X=matrix_completion_sparse_mex(A,d,Omega,X0,options)
% matrix completion: 
% A- given matrix, each row only has the nonzeros indices;
% d-diagonal indices of A
% Omega- visible indices:consists of n vectors, must be symmetric;
% X0 initial-all zeros

% preprocessing:
%mex exactCDmex.c
fprintf('Step 2: matrix factorization...\n');
n=size(A,2);
m=0;
lenA=zeros(n,1);
for i=1:n
	%if (length(A{i})>m)
	%	m=length(A{i});
	%end
	lenA(i)=length(A{i});
end

m=max(lenA);

nA=zeros(n,m);
nO=nA;
for i=1:n
	nA(i,1:length(A{i}))=A{i};
	nO(i,1:length(A{i}))=Omega{i}-1;
end
d=d-1;
nR=nA;
k=size(X0,2);
X=exactCDmex(nA,nR,nO,X0,lenA,d,norm(nA,'fro'),options.maxiter);

end


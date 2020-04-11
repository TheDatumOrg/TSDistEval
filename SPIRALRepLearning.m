function ZRep = SPIRALRepLearning(DS,coeffs)


label_train=DS.TrainClassLabels;
Train=DS.Train;
label_test=DS.TestClassLabels;
Test=DS.Test;

X={};
n=size(Train,1);
for i=1:n
	X{i}=Train(i,:)';
end

for i=n+1:n+size(Test,1)
	X{i}=Test(i-n,:)';
end
n=size(X,2);
%m=n*20*ceil(log(n));
% so that it's comparable to our method
m=n*coeffs;
if (2*m>n*n)
	m=floor(n*n/2);
end
[D,Omega,d]=construct_sparse(X,n,m);
X0=zeros(n,coeffs);
options.maxiter=20;
tic;X_train=matrix_completion_sparse_mex(D,d,Omega,X0,options);toc

Train=[X_train(1:size(Train,1),:)];
Test=[X_train(size(Train,1)+1:size(X_train,1),:)];

ZRep = [Train;Test];

%Train=[label_train,X_train(1:size(Train,1),:)];
%Test=[label_test,X_train(size(Train,1)+1:size(X_train,1),:)];
%csvwrite(strcat(file_dir,filename,'/',filename,'_sparse_Train'),Train);
%csvwrite(strcat(file_dir,filename,'/',filename,'_sparse_Test'),Test);
%save features for Train/Test data

end


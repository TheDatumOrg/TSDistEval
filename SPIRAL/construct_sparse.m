%generating the kernel matrix
function [D,Omega,d]=construct_sparse(X,n,m)
	% use the first n users, and generate approximately m pairs among them
	% mex dtw_c.c;
	fprintf('Step 1: sample and calculate dtw distance...\n')
	D={};
	Omega={};
	d=zeros(n,1);
    length=size(X{1},1);
	wsize=ceil(length/30);
	if wsize>40
		wsize=40;
	end
	if wsize<1
		wsize=1;
	end
	id2d=randsample(n*n,2*m,'false');
	idi=floor((id2d-1)/n)+1;
	idj=id2d-n*(idi-1);
	id=find(idi<idj);
	idi=idi(id);
	idi=idi(1:floor((m-n)/2));
	idj=idj(id);
	idj=idj(1:floor((m-n)/2));
	
	v=zeros(floor((m-n)/2),1);
    nrm=zeros(n,1);
	tic;
	for i=1:n
		nrm(i)=dtw_c(X{i},zeros(1,size(X{i},2)),2);
	end
    	
	for k=1:floor((m-n)/2)
		%v(i)=0;i
		i=idi(k);
		j=idj(k);
		v(k)=(nrm(i)^2+nrm(j)^2-dtw_c(X{i},X{j},wsize)^2)/2/(nrm(i)*nrm(j));
		%v(k)=(nrm(i)^2+nrm(j)^2-dtw_c(X{i},X{j},15)^2)/(nrm(i)^2+nrm(j)^2);
	end
    toc
	col=[idi;idj;(1:n)'];
	row=[idj;idi;(1:n)'];
	v=[v;v;ones(n,1)];
	m=size(col);
	[col,Index]=sort(col);
	row=row(Index);
	v=v(Index);
	start=1;
	nd=1;

	for i=1:n
	    while (true)
			if (nd>m)
				break;
			end
			if (col(nd)~=i)
				break;
			end
			nd=nd+1;
	    end
	    Omega{i}=row(start:nd-1);
	    D{i}=v(start:nd-1);
	    d(i)=find(Omega{i}==i);
	    start=nd;
	end

end


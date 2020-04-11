function [Zexact, Ztop5, Ztop10, Ztop20, Z99per, Z98per, Z97per, Z95per, Z90per, Z85per, Z80per, DistComp, RuntimeNystrom, RuntimeFD]=RepLearnGRAIL(X, Dictionary, gamma)
% Input
% X: original data (nxm)
% Dictionary: kShape's centroids (cxm) or randomly chosen time series
% Dim: Dimensions to keep in the end over the learned representation
% gamma: kernel's parameter
% Output
% Ktilde: Approximated kernel matrix (nxn)
% Z: New learned representation (nxDim)

DistComp = 0;

[nrowsX, ncolumnsX] = size(X);
[nrowsDic, ncolumnsDic] = size(Dictionary);

W = zeros(nrowsDic,nrowsDic);

E = zeros(nrowsX,nrowsDic);

tic;
for i=1:nrowsDic
    for j=1:nrowsDic
        W(i,j) = SINK(Dictionary(i,:),Dictionary(j,:),gamma);
        %DistComp = DistComp + 1;
    end    
end
        
for i=1:nrowsX
    disp(i);
       for j=1:nrowsDic
           E(i,j) = SINK(X(i,:),Dictionary(j,:),gamma);
           %DistComp = DistComp + 1;
       end    
end

[Ve, Va] = eig(W);
va = diag(Va);
inVa = diag(va.^(-0.5));
Zexact = E * Ve * inVa;

RuntimeNystrom = toc;

Zexact = CheckNaNInfComplex(Zexact);

tic;
%[BSketch, ~] = FrequentDirections(Zexact, ceil(0.5*size(Zexact,2)));

%[V2, L2] = eig(BSketch'*BSketch);
[V2, L2] = eig(Zexact'*Zexact);
eigvalue = diag(L2);     
[dump, index] = sort(-eigvalue);
eigvalue = eigvalue(index);
V2 = V2(:, index);

RuntimeFD = toc;

    VarExplainedCumSum = cumsum(eigvalue)/sum(eigvalue);

    DimFor99 = find(VarExplainedCumSum>=0.99,1);
    DimFor98 = find(VarExplainedCumSum>=0.98,1);
    DimFor97 = find(VarExplainedCumSum>=0.97,1);
    DimFor95 = find(VarExplainedCumSum>=0.95,1);
    DimFor90 = find(VarExplainedCumSum>=0.90,1);
    DimFor85 = find(VarExplainedCumSum>=0.85,1);
    DimFor80 = find(VarExplainedCumSum>=0.80,1);

    Ztop5 = CheckNaNInfComplex( Zexact*V2(:,1:5) );
    Ztop10 = CheckNaNInfComplex( Zexact*V2(:,1:10) );
    Ztop20 = CheckNaNInfComplex( Zexact*V2(:,1:20) );

    Z99per = CheckNaNInfComplex( Zexact*V2(:,1:DimFor99) );
    Z98per = CheckNaNInfComplex( Zexact*V2(:,1:DimFor98) );
    Z97per = CheckNaNInfComplex( Zexact*V2(:,1:DimFor97) );
    Z95per = CheckNaNInfComplex( Zexact*V2(:,1:DimFor95) );
    Z90per = CheckNaNInfComplex( Zexact*V2(:,1:DimFor90) );
    Z85per = CheckNaNInfComplex( Zexact*V2(:,1:DimFor85) );
    Z80per = CheckNaNInfComplex( Zexact*V2(:,1:DimFor80) );

end

function Z = CheckNaNInfComplex(Z)

    for i=1:size(Z,1)
        for j=1:size(Z,2)
            if (isnan(Z(i,j)) || isinf(Z(i,j)) || ~isreal(Z(i,j))) 
                Z(i,j)=0;
            end
        end
    end

end
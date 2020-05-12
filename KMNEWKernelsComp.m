function DM = KMNEWKernelsComp(X, DistanceIndex, Parameter1, Parameter2)

    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('slidingmeasures/.'));
    addpath(genpath('elasticmeasures/.'));
    addpath(genpath('kernelmeasures/.'));
    addpath(genpath('kernelmeasuresnew/.'));
    
    javaaddpath('./timeseries-1.0-SNAPSHOT.jar');
    javaaddpath('./simcompare.jar');
    obj = edu.uchicago.cs.tsdb.Distance;
    
    [m, TSLength] = size(X);

    DM = zeros(m,m);
                        
    for i=1:m-1
        disp(i);
        rowi = X(i,:);
        tmpVector = zeros(1,m);
           for j=i+1:m
                rowj = X(j,:); 
                
                
                if DistanceIndex==1
                    tmpVector(j) = LinearNCCc(rowi,rowj);
                elseif DistanceIndex==2
                    tmpVector(j) = GaussianNCCc(rowi,rowj, Parameter1);
                elseif DistanceIndex==3
                    tmpVector(j) = LogKernelNCCc(rowi,rowj, Parameter1);
                elseif DistanceIndex==4
                    tmpVector(j) = LogisticKernelNCCc(rowi,rowj);
                elseif DistanceIndex==5
                    tmpVector(j) = PolynomialNCCc(rowi,rowj, Parameter1, Parameter2);
                elseif DistanceIndex==6
                    tmpVector(j) = TanhNCCc(rowi,rowj, Parameter1);
                elseif DistanceIndex==7
                    tmpVector(j) = MultiQuadNCCc(rowi,rowj, Parameter1);
                elseif DistanceIndex==8
                    tmpVector(j) = RationalQuadNCCc(rowi,rowj, Parameter1);
                elseif DistanceIndex==9
                    tmpVector(j) = InverseMultiQuadNCCc(rowi,rowj, Parameter1);
                elseif DistanceIndex==10
                    tmpVector(j) = CauchyKernelNCCc(rowi,rowj, Parameter1);
                end 
                
                                
           end    
        DM(i,:) = tmpVector;   
    end

    for i=1:m-1
           for j=i+1:m
                DM(j,i) = DM(i,j);
           end    
    end
    
    for i=1:m
        
                if DistanceIndex==1
                    DM(i,i) = LinearNCCc(X(i,:), X(i,:));
                elseif DistanceIndex==2
                    DM(i,i) = GaussianNCCc(X(i,:), X(i,:), Parameter1);
                elseif DistanceIndex==3
                    DM(i,i) = LogKernelNCCc(X(i,:), X(i,:), Parameter1);
                elseif DistanceIndex==4
                    DM(i,i) = LogisticKernelNCCc(X(i,:), X(i,:));
                elseif DistanceIndex==5
                    DM(i,i) = PolynomialNCCc(X(i,:), X(i,:), Parameter1, Parameter2);
                elseif DistanceIndex==6
                    DM(i,i) = TanhNCCc(X(i,:), X(i,:), Parameter1);
                elseif DistanceIndex==7
                    DM(i,i) = MultiQuadNCCc(X(i,:), X(i,:), Parameter1);
                elseif DistanceIndex==8
                    DM(i,i) = RationalQuadNCCc(X(i,:), X(i,:), Parameter1);
                elseif DistanceIndex==9
                    DM(i,i) = InverseMultiQuadNCCc(X(i,:), X(i,:), Parameter1);
                elseif DistanceIndex==10
                    DM(i,i) = CauchyKernelNCCc(X(i,:), X(i,:), Parameter1);
                end 
        
    end

end
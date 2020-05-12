function DM = KMNEWKernelsComp_TestToTrain(X, Y, DistanceIndex, Parameter1, Parameter2)

    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('slidingmeasures/.'));
    addpath(genpath('elasticmeasures/.'));
    addpath(genpath('kernelmeasures/.'));
    addpath(genpath('kernelmeasuresnew/.'));
    
    javaaddpath('./timeseries-1.0-SNAPSHOT.jar');
    javaaddpath('./simcompare.jar');
    obj = edu.uchicago.cs.tsdb.Distance;
    
    [nrowsX, TSLength]=size(X);
    [nrowsY, ~]=size(Y);

    DM = zeros(nrowsX,nrowsY);

    for i=1:nrowsX
            disp(i);
            tmpX = X(i,:);
            for j=1:nrowsY    
    
                if DistanceIndex==1
                    DM(i,j) = LinearNCCc(tmpX, Y(j,:));
                elseif DistanceIndex==2
                    DM(i,j) = GaussianNCCc(tmpX, Y(j,:), Parameter1);
                elseif DistanceIndex==3
                    DM(i,j) = LogKernelNCCc(tmpX, Y(j,:), Parameter1);
                elseif DistanceIndex==4
                    DM(i,j) = LogisticKernelNCCc(tmpX, Y(j,:));
                elseif DistanceIndex==5
                    DM(i,j) = PolynomialNCCc(tmpX, Y(j,:), Parameter1, Parameter2);
                elseif DistanceIndex==6
                    DM(i,j) = TanhNCCc(tmpX, Y(j,:), Parameter1);
                elseif DistanceIndex==7
                    DM(i,j) = MultiQuadNCCc(tmpX, Y(j,:), Parameter1);
                elseif DistanceIndex==8
                    DM(i,j) = RationalQuadNCCc(tmpX, Y(j,:), Parameter1);
                elseif DistanceIndex==9
                    DM(i,j) = InverseMultiQuadNCCc(tmpX, Y(j,:), Parameter1);
                elseif DistanceIndex==10
                    DM(i,j) = CauchyKernelNCCc(tmpX, Y(j,:), Parameter1);
                end       
            end    
    end
end
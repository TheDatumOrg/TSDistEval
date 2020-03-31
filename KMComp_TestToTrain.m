function DM = KMComp_TestToTrain(X, Y, DistanceIndex, Parameter1, Parameter2)

    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('slidingmeasures/.'));
    addpath(genpath('elasticmeasures/.'));
    addpath(genpath('kernelmeasures/.'));
    
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
                    DM(i,j) = SINK(tmpX, Y(j,:), Parameter1);
                elseif DistanceIndex==2
                    DM(i,j) = logGAK(tmpX',Y(j,:)', Parameter1, 0);
                elseif DistanceIndex==3
                    DM(i,j) = KDTWNorm_mex(tmpX, Y(j,:), Parameter1);
                end       
            end    
    end
end
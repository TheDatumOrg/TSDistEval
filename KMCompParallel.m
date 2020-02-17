function DM = KMCompParallel(X, DistanceIndex, Parameter1, Parameter2)

    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('slidingmeasures/.'));
    addpath(genpath('elasticmeasures/.'));
    addpath(genpath('kernelmeasures/.'));
  
   
    [m, TSLength] = size(X);

    DM = zeros(m,m);
                        
    for i=1:m-1
        disp(i);
        rowi = X(i,:);
        tmpVector = zeros(1,m);
           parfor j=i+1:m
                rowj = X(j,:); 
                if DistanceIndex==1
                    tmpVector(j) = SINK(rowi,rowj,Parameter1);
                elseif DistanceIndex==2
                    tmpVector(j) = logGAK(rowi',rowj',Parameter1,0);
                elseif DistanceIndex==3
                    tmpVector(j) = KDTWNorm_mex(rowi,rowj,Parameter1);

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
            DM(i,i) = SINK(X(i,:),X(i,:),Parameter1);
        elseif DistanceIndex==2
            DM(i,i) = logGAK(X(i,:)',X(i,:)',Parameter1,0);
        elseif DistanceIndex==3
            DM(i,i) = KDTWNorm_mex(X(i,:),X(i,:), Parameter1);
        end        
        
    end

end
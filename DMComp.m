function DM = DMComp(X, DistanceIndex, Parameter1)

    [m, ~] = size(X);

    DM = zeros(m,m);
                        
    parfor i=1:m-1
        %disp(i);
        rowi = X(i,:);
        tmpVector = zeros(1,m);
           for j=i+1:m
                rowj = X(j,:); 
                if DistanceIndex==1
                    tmpVector(j) = ED(rowi,rowj);
                elseif DistanceIndex==2
                    tmpVector(j) = 1-max( NCCc(rowi,rowj));
                elseif DistanceIndex==3
                    tmpVector(j) = MSM_mex(rowi,rowj,Parameter1);
                elseif DistanceIndex==4
                    tmpVector(j) = dtw(rowi,rowj,Parameter1);    
                elseif DistanceIndex==5
                    tmpVector(j) = edr(rowi,rowj,Parameter1);  
                elseif DistanceIndex==6
                    tmpVector(j) = SINK(rowi,rowj,Parameter1);    
                elseif DistanceIndex==7
                    tmpVector(j) = logGAK(rowi',rowj',Parameter1,0);
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
            DM(i,i) = ED(X(i,:),X(i,:));
        elseif DistanceIndex==2
            DM(i,i) = 1-max( NCCc(X(i,:),X(i,:)) );
        elseif DistanceIndex==3
            DM(i,i) = MSM_mex(X(i,:),X(i,:), Parameter1);
        elseif DistanceIndex==4
            DM(i,i) = dtw(X(i,:),X(i,:), Parameter1);
        elseif DistanceIndex==5
            DM(i,i) = edr(X(i,:),X(i,:), Parameter1);
        elseif DistanceIndex==6
            DM(i,i) = SINK(X(i,:),X(i,:), Parameter1);   
        elseif DistanceIndex==7
            DM(i,i) = logGAK(X(i,:)',X(i,:)',Parameter1,0);
        end        
        
    end

end

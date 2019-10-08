function [acc,issues,zerodistances,nandistances,infdistances,complexdistances] = OneNNClassifierSimilarity(DS, DistanceIndex)
    
    issues = 0;
    zerodistances = 0;
    nandistances = 0;
    infdistances = 0;
    complexdistances = 0;
    
    acc = 0;
    
    for id = 1 : DS.TestInstancesCount
        %disp(id);
        classify_this = DS.Test(id,:);
        
        best_so_far = -inf;

        for i = 1 : DS.TrainInstancesCount
            
            compare_to_this = DS.Train(i,:);

            % MinMax goes to 0 1
            %compare_to_this=mat2gray(compare_to_this);
            %classify_this=mat2gray(classify_this);
            
            % MinMax 
            %compare_to_this = minmaxnormalization(compare_to_this);
            %classify_this = minmaxnormalization(classify_this);
            
            % ScaleNorm
            %[compare_to_this,classify_this] = scale_d(compare_to_this,classify_this);

            %compare_to_this = sigmoidnormalization(compare_to_this);
            %classify_this = sigmoidnormalization(classify_this);
            
            %compare_to_this = tanhnormalization(compare_to_this);
            %classify_this = tanhnormalization(classify_this);
            
            compare_to_this = mediannormalization(compare_to_this);
            classify_this = mediannormalization(classify_this);
            
            % 46 - inner product (similarity)   GOOD
            % 47 - Harnominc mean (similarity)  GOOD
            % 48 - Fidelity (similarity)        GOOD
            % 49 - Kumar Hassebrook         GOOD
    
            
            if DistanceIndex==46
                distance = innerproduct(compare_to_this, classify_this);
            elseif DistanceIndex==47
                distance = harmonicmean(compare_to_this, classify_this);
            elseif DistanceIndex==48
                distance = fidelity(compare_to_this, classify_this);
            elseif DistanceIndex==49
                distance = kumarhassebrook(compare_to_this, classify_this);
            end
            
            if distance==0
                zerodistances=1;
                issues=1;
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
                
            end
            if isnan(distance)
                nandistances=1;
                issues=1;
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
            end            
            
            if isinf(distance)
                infdistances=1;
                issues=1;
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
            end
            
            if ~isreal(distance)
                distance = abs(distance);
                complexdistances=1;
                issues=1;
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
            end
            
            if distance > best_so_far
                class = DS.TrainClassLabels(i);
                best_so_far = distance;
            end
        end
        
        if (DS.TestClassLabels(id) == class)
            acc = acc + 1;
        end
    end
    
    acc = acc / DS.TestInstancesCount;
end

function acc = OneNNClassifierSimilarity(DS, DistanceIndex)
    
    acc = 0;
    
    for id = 1 : DS.TestInstancesCount
        %disp(id);
        classify_this = DS.Test(id,:);
        
        best_so_far = -inf;

        for i = 1 : DS.TrainInstancesCount
            
            compare_to_this = DS.Train(i,:);

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
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
            end
            if isnan(distance) || isinf(distance) || ~isreal(distance) || ~isscalar(distance)
                disp(distance)
                disp(id)
                disp(i)
               error('########### ERROR #############')
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

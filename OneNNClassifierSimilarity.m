function acc = OneNNClassifierSimilarity(DS, DistanceIndex)
    
    acc = 0;
    
    for id = 1 : DS.TestInstancesCount
        disp(id);
        classify_this = DS.Test(id,:);
        
        best_so_far = -999999999999;

        for i = 1 : DS.TrainInstancesCount
            
            compare_to_this = DS.Train(i,:);

            if DistanceIndex==40
                distance = intersection(compare_to_this, classify_this);
            elseif DistanceIndex==41
                distance = motyka(compare_to_this, classify_this);
            elseif DistanceIndex==42
                distance = pdist2(compare_to_this, classify_this,'cityblock')
            elseif DistanceIndex==43
                distance = czekanowski(compare_to_this, classify_this);
            elseif DistanceIndex==44
                distance = czekanowski(compare_to_this, classify_this);
            elseif DistanceIndex==45
                distance = czekanowski(compare_to_this, classify_this);
            elseif DistanceIndex==46
                distance = czekanowski(compare_to_this, classify_this);
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

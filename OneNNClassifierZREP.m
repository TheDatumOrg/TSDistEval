function acc = OneNNClassifierZREP(DS,ZRepresentation)
    
    ZRepTrain = ZRepresentation(1:DS.TrainInstancesCount,:);
    ZRepTest = ZRepresentation(DS.TrainInstancesCount+1:end,:);

    acc = 0;
    
    for id = 1 : DS.TestInstancesCount
        
        %classify_this = DS.Test(id,:);
        classify_this = ZRepTest(id,:);
        
        best_so_far = inf;
        %best_so_far = 0;
        for i = 1 : DS.TrainInstancesCount
            
            %compare_to_this = DS.Train(i,:);
            compare_to_this = ZRepTrain(i,:);

            distance = ED(compare_to_this, classify_this)^2;

            
           
            if distance < best_so_far
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

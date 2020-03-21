function acc = OneNNClassifierED(DS)
    
    acc = 0;
    
    for id = 1 : DS.TestInstancesCount
        disp(id);
        classify_this = DS.Test(id,:);
        
        best_so_far = inf;
        %best_so_far = -999999999999;

        for i = 1 : DS.TrainInstancesCount
            
            compare_to_this = DS.Train(i,:);

            distance = ED(compare_to_this, classify_this);
            %distance = logGAK(compare_to_this', classify_this',0.1,0);

            %if distance > best_so_far
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

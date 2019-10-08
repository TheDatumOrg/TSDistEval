function acc = LOOCMinkowski(DS,param1)
    
    acc = 0;
    
    for id = 1 : DS.TrainInstancesCount

        classify_this = DS.Train(id,:);

        best_so_far = inf;

        for i = 1 : DS.TrainInstancesCount

            if (i ~= id)
    
                compare_to_this = DS.Train(i,:);    
                
                distance = minkowski(compare_to_this,classify_this, param1);

                if distance < best_so_far
                    class = DS.TrainClassLabels(i);
                    best_so_far = distance;
                end
            end

        end

        if (DS.TrainClassLabels(id) == class)
            acc = acc + 1;
        end

    end
    acc = acc / DS.TrainInstancesCount;
end
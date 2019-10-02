function acc = LOOCWITHDM(DS, DMTRAIN)
    
    acc = 0;
    
    for id = 1 : DS.TrainInstancesCount

        %best_so_far = inf;
        best_so_far = -9999999;

        for i = 1 : DS.TrainInstancesCount

            if (i ~= id)

                distance = DMTRAIN(i, id);

                if distance > best_so_far
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
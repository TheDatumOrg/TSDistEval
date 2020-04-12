function acc = LeaveOneOutClassifierZREP(DS,ZRepresentation)

    ZRepTrain = ZRepresentation(1:DS.TrainInstancesCount,:);

    acc = 0;

    for id = 1 : DS.TrainInstancesCount

        %classify_this = DS.Train(id,:);
        classify_this = ZRepTrain(id,:);

        best_so_far = inf;

        for i = 1 : DS.TrainInstancesCount

            if (i ~= id)

                %compare_to_this = DS.Train(i,:);                
                compare_to_this = ZRepTrain(i,:);
                
                distance = ED(compare_to_this, classify_this)^2;

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
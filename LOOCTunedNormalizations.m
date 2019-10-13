function acc = LOOCTunedNormalizations(DS, NormalizationIndex, Parameter1)
    
    acc = 0;
    
    for id = 1 : DS.TrainInstancesCount

        classify_this = DS.Train(id,:);

            if NormalizationIndex==1
                classify_this = MinMaxNorm(classify_this,0.001,1);
            elseif NormalizationIndex==2
                classify_this = SlidingZscore(classify_this, Parameter1);
            end
            
        best_so_far = inf;

        for i = 1 : DS.TrainInstancesCount

            if (i ~= id)
    
                compare_to_this = DS.Train(i,:);  
                
                if NormalizationIndex==1
                    compare_to_this = MinMaxNorm(compare_to_this,0.001,Parameter1);
                elseif NormalizationIndex==2
                    compare_to_this = SlidingZscore(compare_to_this, Parameter1);
                end
                
                distance = euclidean(compare_to_this,classify_this);

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
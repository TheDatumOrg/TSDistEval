function acc = LOOCMinkowski(DS,param1, NormalizationIndex)
    
    acc = 0;
    
    for id = 1 : DS.TrainInstancesCount

        classify_this = DS.Train(id,:);

            if NormalizationIndex==2
                classify_this = MinMaxNorm(classify_this,0.001,1);
            elseif NormalizationIndex==3
                classify_this = UnitLengthNorm(classify_this);
            elseif NormalizationIndex==4
                classify_this = MeanNorm(classify_this);
            elseif NormalizationIndex==5
                classify_this = MedianNorm(classify_this);
            elseif NormalizationIndex==6
            elseif NormalizationIndex==7  
                classify_this = SigmoidNorm(classify_this);
            elseif NormalizationIndex==8
                classify_this = TanhNorm(classify_this);
            end
            
        best_so_far = inf;

        for i = 1 : DS.TrainInstancesCount

            if (i ~= id)
    
                compare_to_this = DS.Train(i,:);  
                
                if NormalizationIndex==2
                    compare_to_this = MinMaxNorm(compare_to_this,0.001,1);
                elseif NormalizationIndex==3
                    compare_to_this = UnitLengthNorm(compare_to_this);
                elseif NormalizationIndex==4
                    compare_to_this = MeanNorm(compare_to_this);
                elseif NormalizationIndex==5
                    compare_to_this = MedianNorm(compare_to_this);
                elseif NormalizationIndex==6
                    [classify_this,compare_to_this] = AdaptiveScaling(classify_this,compare_to_this);
                elseif NormalizationIndex==7  
                    compare_to_this = SigmoidNorm(compare_to_this);
                elseif NormalizationIndex==8
                    compare_to_this = TanhNorm(compare_to_this);
                end
                
                distance = minkowski(compare_to_this,classify_this, param1);
                distance

                if distance < best_so_far
                    class = DS.TrainClassLabels(i);
                    best_so_far = distance;
                end
            end

        end
class
        if (DS.TrainClassLabels(id) == class)
            acc = acc + 1;
        end

    end
    acc = acc / DS.TrainInstancesCount;
end
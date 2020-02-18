function [acc,issues,zerodistances,nandistances,infdistances,complexdistances] = OneNNClassifierSimilarity(DS, DistanceIndex, NormalizationIndex)
    
    issues = 0;
    zerodistances = 0;
    nandistances = 0;
    infdistances = 0;
    complexdistances = 0;
    
    acc = 0;
    
    for id = 1 : DS.TestInstancesCount
        %disp(id);
        classify_this = DS.Test(id,:);
 
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
            
        best_so_far = -inf;

        for i = 1 : DS.TrainInstancesCount
            
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

            % 46 - inner product (similarity)   GOOD
            % 47 - Harnominc mean (similarity)  GOOD
            % 48 - Fidelity (similarity)        GOOD
            % 49 - Kumar Hassebrook         GOOD
    
            
            if DistanceIndex==47
                distance = innerproduct(compare_to_this, classify_this);
            elseif DistanceIndex==48
                distance = harmonicmean(compare_to_this, classify_this);
            elseif DistanceIndex==49
                distance = fidelity(compare_to_this, classify_this);
            elseif DistanceIndex==50
                distance = kumarhassebrook(compare_to_this, classify_this);
            elseif DistanceIndex==51
                distance = max(NCC(compare_to_this, classify_this));
            elseif DistanceIndex==52
                distance = max(NCCu(compare_to_this, classify_this));
            elseif DistanceIndex==53
                distance = max(NCCb(compare_to_this, classify_this));
            elseif DistanceIndex==54
                distance = max(NCCc(compare_to_this, classify_this));
            end
            
            if distance==0
                zerodistances=1;
                issues=1;
                %disp(distance)
                %disp(id)
                %disp(i)
                %disp('*********** 0 WARNING ************')
                
            end
            if isnan(distance)
                nandistances=1;
                issues=1;
                %disp(distance)
                %disp(id)
                %disp(i)
                %disp('*********** NaN WARNING ************')
            end            
            
            if isinf(distance)
                infdistances=1;
                issues=1;
                %disp(distance)
                %disp(id)
                %disp(i)
                %disp('*********** Inf WARNING ************')
            end
            
            if ~isreal(distance)
                %disp(distance);
                distance = abs(distance);
                complexdistances=1;
                issues=1;
                %disp(distance)
                %disp(id)
                %disp(i)
                %disp('*********** Complex WARNING ************')
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

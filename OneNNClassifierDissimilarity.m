function [acc,issues,zerodistances,nandistances,infdistances,complexdistances] = OneNNClassifierDissimilarity(DS, DistanceIndex,  NormalizationIndex)
    
    javaaddpath('./timeseries-1.0-SNAPSHOT.jar');
    javaaddpath('./simcompare.jar');
    obj = edu.uchicago.cs.tsdb.Distance;
    
    issues = 0;
    zerodistances = 0;
    nandistances = 0;
    infdistances = 0;
    complexdistances = 0;

    acc = 0;
    
    for id = 1 : DS.TestInstancesCount
        %disp(id);
        classify_this = DS.Test(id,:);
        
        best_so_far = inf;

        for i = 1 : DS.TrainInstancesCount
            
            compare_to_this = DS.Train(i,:);
    
            if NormalizationIndex==1                
            elseif NormalizationIndex==2
                compare_to_this = MinMaxNorm(compare_to_this,0.001,1);
                classify_this = MinMaxNorm(classify_this,0.001,1);
            elseif NormalizationIndex==3
                compare_to_this = UnitLengthNorm(compare_to_this);
                classify_this = UnitLengthNorm(classify_this);
            elseif NormalizationIndex==4
                compare_to_this = MeanNorm(compare_to_this);
                classify_this = MeanNorm(classify_this);
            elseif NormalizationIndex==5
                compare_to_this = MedianNorm(compare_to_this);
                classify_this = MedianNorm(classify_this);
            elseif NormalizationIndex==6
                [compare_to_this,classify_this] = AdaptiveScaling(compare_to_this,classify_this);
            elseif NormalizationIndex==7    
                compare_to_this = SigmoidNorm(compare_to_this);
                classify_this = SigmoidNorm(classify_this);
            elseif NormalizationIndex==8
                compare_to_this = TanhNorm(compare_to_this);
                classify_this = TanhNorm(classify_this);
            elseif NormalizationIndex==9
            end
            
            if DistanceIndex==1
                distance = euclidean(compare_to_this, classify_this);
            elseif DistanceIndex==2
                distance = squared_euclidean(compare_to_this, classify_this);
            elseif DistanceIndex==3
                distance = obj.DissimDistance(compare_to_this, classify_this);    
            elseif DistanceIndex==4
                distance = manhattan(compare_to_this, classify_this);     
            elseif DistanceIndex==5
                distance = jaccard(compare_to_this, classify_this);  
            elseif DistanceIndex==6
                distance = dice(compare_to_this, classify_this); 
            elseif DistanceIndex==7
                distance = avg_l1_linf(compare_to_this, classify_this); 
            elseif DistanceIndex==8
                distance = lorentzian(compare_to_this, classify_this); 
            elseif DistanceIndex==9
                distance = chebyshev(compare_to_this, classify_this); 
            elseif DistanceIndex==10
                distance = hellinger(compare_to_this, classify_this); 
            elseif DistanceIndex==11
                distance = kumar_johnson(compare_to_this, classify_this); 
            elseif DistanceIndex==12
                distance = divergence(compare_to_this, classify_this); 
            elseif DistanceIndex==13
                distance = emanon2(compare_to_this, classify_this); 
            elseif DistanceIndex==14
                distance = emanon3(compare_to_this, classify_this); 
            elseif DistanceIndex==15
                distance = clark(compare_to_this, classify_this) 
            elseif DistanceIndex==16
                distance = soergel(compare_to_this, classify_this); 
            elseif DistanceIndex==17
                distance = canberra(compare_to_this, classify_this); 
            elseif DistanceIndex==18
                distance = additive_symm_chi(compare_to_this, classify_this); 
            elseif DistanceIndex==19
                distance = squared_chi(compare_to_this, classify_this); 
            elseif DistanceIndex==20
                distance = max_symmetric_chi(compare_to_this, classify_this); 
            elseif DistanceIndex==21
                distance = min_symmetric_chi(compare_to_this, classify_this);   
            elseif DistanceIndex==22
                distance = kulczynski(compare_to_this, classify_this); 
            elseif DistanceIndex==23
                distance = tanimoto(compare_to_this, classify_this); 
            elseif DistanceIndex==24
                distance = wavehedges(compare_to_this, classify_this); 
            elseif DistanceIndex==25
                distance = taneja(compare_to_this, classify_this); 
            elseif DistanceIndex==26
                distance = topsoe(compare_to_this, classify_this);              
            elseif DistanceIndex==27
                distance = vicis_wave_hedges(compare_to_this, classify_this); 
            elseif DistanceIndex==28
                distance = square_chord(compare_to_this, classify_this); 
            elseif DistanceIndex==29
                distance = kullback(compare_to_this, classify_this); 
            elseif DistanceIndex==30
                distance = neyman(compare_to_this, classify_this); 
            elseif DistanceIndex==31
                distance = k_divergence(compare_to_this, classify_this); 
            elseif DistanceIndex==32
                distance = jeffrey(compare_to_this, classify_this); 
            elseif DistanceIndex==33
                distance = jensen_difference(compare_to_this, classify_this);                 
            elseif DistanceIndex==34
                distance = pearson(compare_to_this, classify_this);         
            elseif DistanceIndex==35
                distance = sorensen(compare_to_this, classify_this);
            elseif DistanceIndex==36
                distance = prob_symmetric_chi(compare_to_this, classify_this);            
            elseif DistanceIndex==37
                distance = gower(compare_to_this, classify_this);              
            elseif DistanceIndex==38
                distance = intersection(compare_to_this, classify_this);  
            elseif DistanceIndex==39
                distance = motyka(compare_to_this, classify_this);  
            elseif DistanceIndex==40
                distance = cosine(compare_to_this, classify_this);  
            elseif DistanceIndex==41
                distance = matusita(compare_to_this, classify_this);  
            elseif DistanceIndex==42
                distance = bhattacharyya(compare_to_this, classify_this);  
            elseif DistanceIndex==43
                distance = czekanowski(compare_to_this, classify_this);  
            elseif DistanceIndex==44
                distance = jansen_shannon(compare_to_this, classify_this);  
            elseif DistanceIndex==45
                distance = emanon4(compare_to_this, classify_this);  
            elseif DistanceIndex==46
                distance = PairWiseScalingDistance(compare_to_this, classify_this);     
            end

            if distance==0
                zerodistances=1;
                issues=1;
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
                
            end
            if isnan(distance)
                nandistances=1;
                issues=1;
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
            end            
            
            if isinf(distance)
                infdistances=1;
                issues=1;
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
            end
            
            if ~isreal(distance)
                distance = abs(distance);
                complexdistances=1;
                issues=1;
                disp(distance)
                disp(id)
                disp(i)
                disp('*********** WARNING ************')
            end
            
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
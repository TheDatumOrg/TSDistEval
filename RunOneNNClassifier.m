function RunOneNNClassifier(DataSetStartIndex, DataSetEndIndex, DistanceIndex, NormalizationIndex)  
    
    % Normalization
    % 1 - ZScoreNorm
    % 2 - MinMaxNorm
    % 3 - UnitLengthNorm
    % 4 - MeanNorm
    % 5 - MedianNorm
    % 6 - AdaptiveNorm
    % 7 - Sigmoid
    % 8 - Tanh
    
    Normalizations = [cellstr('ZScoreNorm'), 'MinMaxNorm', 'UnitLengthNorm', 'MeanNorm', 'MedianNorm', 'AdaptiveNorm' ...
        'Sigmoid', 'Tanh'];
    
    addpath(genpath('normalizations/.'));
    
    % Dissimilarity Methods over pairs of probability density functions
    % Minkowski needs tuning so not included here - different script
    % Abs Euclidean was removed as it gives same results as ED (52 overall)
    % 1 - Euclidean                 GOOD
    % 2 - Squared Euclidean         GOOD
    % 3 - DISSIM (java code)        GOOD 
    % 4 - Manhattan                 GOOD
    % 5 - Jaccard                   GOOD (similar to tanimoto)
    % 6 - Dice                      GOOD 
    % 7 - Average l1/linf           GOOD
    % 8 - Lorentzian                GOOD
    % 9 - Chebyshev                 GOOD
    % 10 - Hellinger                GOOD
    % 11 - Kumar Johnson            GOOD
    % 12 - Divergence               GOOD
    % 13 - Emanon2                  GOOD
    % 14 - Emanon3                  GOOD
    % 15 - Clark                    GOOD (PROBLEM!)
    % 16 - Soergel                  GOOD (same resutls for all pairs)
    % 17 - Canberra                 GOOD
    % 18 - Additive_symm_chi        GOOD
    % 19 - Squared_chi              GOOD
    % 20 - Max_symmetric_chi        GOOD (return whole vector - they forgot sum)
    % 21 - Min_symmetric_chi        GOOD (return whole vector - they forgot sum)
    % 22 - Kulczynski               GOOD (same results for all pairs)
    % 23 - Tanimoto                 GOOD (same as jaccard distance)
    % 24 - Wavehedges               GOOD
    % 25 - Taneja                   GOOD
    % 26 - Topsoe                   GOOD
    % 27 - Vicis_wave_hedges        GOOD
    % 28 - Square_chord             GOOD
    % 29 - Kullback                 GOOD
    % 30 - Neyman                   GOOD
    % 31 - K_divergence             GOOD
    % 32 - Jeffrey                  GOOD
    % 33 - Jensen_difference        GOOD
    % 34 - Pearson                  GOOD
    % 35 - Sorensen                 GOOD
    % 36 - Prob_symmetric_chi       GOOD
    % 37 - Gower                    GOOD (manhattan divided by length)
    % 38 - Intersection (this is distance) GOOD (manhattan divided by 2)
    % 39 - Motyka (this is distance) GOOD (sorense in half)
    % 40 - Cosine distance          GOOD
    % 41 - Matusita                 GOOD
    % 42 - Bhattacharyya            GOOD
    % 43 - Czekanowski              GOOD
    % 44 - Jansen_shannon           GOOD
    % 45 - Emanon4                  GOOD
    % 46 - PairWiseScalingDistance  GOOD
    
    % Similarities
    % 47 - inner product (similarity)   GOOD
    % 48 - Harnominc mean (similarity)  GOOD
    % 49 - Fidelity (similarity)        GOOD (PROBLEM!!)
    % 50 - Kumar Hassebrook             GOOD
    
    % NCC measures
    % 51 - NCC 
    % 52 - NCCu
    % 53 - NCCb
    % 54 - NCCc

    Methods = [cellstr('ED'), 'SQRTED', 'DISSIM', 'Manhattan', 'Jaccard', 'Dice', 'AVG_l1_linf', 'Lorentzian' ...
        'Chebyshev', 'Hellinger', 'KumarJohnson', 'Divergence', 'Emanon2', 'Emanon3', 'Clark', 'Soergel' ...
        'Canberra', 'Additive_symm_chi', 'Squared_chi', 'Max_symmetric_chi', 'Min_symmetric_chi' ...
        'Kulczynski', 'Tanimoto', 'Wavehedges', 'Taneja', 'Topsoe', 'Vicis_wave_hedges', 'Square_chord', 'Kullback' ...
        'Neyman', 'K_divergence', 'Jeffrey', 'Jensen_difference', 'Pearson', 'Sorensen', 'Prob_symmetric_chi' ...
        'Gower','Intersection', 'Motyka', 'Cosine', 'Matusita', 'Bhattacharyya', 'Czekanowski', 'Jansen_shannon', 'Emanon4', 'PairWiseScalingDistance' ...
        'InnerProduct', 'HarmonicMean', 'Fidelity', 'KumarHassebrook' ...
        'NCC', 'NCCu', 'NCCb', 'NCCc'];
    
    addpath(genpath('distancemeasures/.'));
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018-NEW/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, ~] = sort(Datasets);

    Results1 = zeros(length(Datasets),1);
    Results2 = zeros(length(Datasets),5);
    
    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    disp(['Dataset being processed: ', char(Datasets(i))]);
                    DS = LoadUCRdataset(char(Datasets(i)));

                    if DistanceIndex>=47
                        [acc,issues,zerodistances,nandistances,infdistances,complexdistances] = OneNNClassifierSimilarity(DS, DistanceIndex, NormalizationIndex);
                    else
                        [acc,issues,zerodistances,nandistances,infdistances,complexdistances] = OneNNClassifierDissimilarity(DS, DistanceIndex, NormalizationIndex);
                    end
                    
                    Results1(i,1) = acc;
                    Results2(i,1) = issues;
                    Results2(i,2) = zerodistances;
                    Results2(i,3) = nandistances;
                    Results2(i,4) = infdistances;
                    Results2(i,5) = complexdistances;
   
            end
            % z-normalization
            dlmwrite( strcat('./RESULTS/RESULTS_RunONNC_ACCURACY_', char(Methods(DistanceIndex)), '_', char(Normalizations(NormalizationIndex)), '_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results1, 'delimiter', ',');    
            dlmwrite( strcat('./RESULTS/RESULTS_RunONNC_ISSUES_', char(Methods(DistanceIndex)), '_', char(Normalizations(NormalizationIndex)), '_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results2, 'delimiter', ',');    
    
    end
    
end


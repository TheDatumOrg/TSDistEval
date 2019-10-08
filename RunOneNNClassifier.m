function RunOneNNClassifier(DataSetStartIndex, DataSetEndIndex, DistanceIndex)  
    
    % Dissimilarity Methods over pairs of probability density functions
    % 1 - Euclidean                 GOOD
    % 2 - Squared Euclidean         GOOD
    % 3 - Absolute Euclidean        GOOD (not yet found in paper)
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
    
    % Similarities
    % 46 - inner product (similarity)   GOOD
    % 47 - Harnominc mean (similarity)  GOOD
    % 48 - Fidelity (similarity)        GOOD (PROBLEM!!)
    % 49 - Kumar Hassebrook         GOOD

    Methods = [cellstr('ED'), 'SQRTED', 'ABSED', 'Manhattan', 'Jaccard', 'Dice', 'AVG_l1_linf', 'Lorentzian' ...
        'Chebyshev', 'Hellinger', 'KumarJohnson', 'Divergence', 'Emanon2', 'Emanon3', 'Clark', 'Soergel' ...
        'Canberra', 'Additive_symm_chi', 'Squared_chi', 'Max_symmetric_chi', 'Min_symmetric_chi' ...
        'Kulczynski', 'Tanimoto', 'Wavehedges', 'Taneja', 'Topsoe', 'Vicis_wave_hedges', 'Square_chord', 'Kullback' ...
        'Neyman', 'K_divergence', 'Jeffrey', 'Jensen_difference', 'Pearson', 'Sorensen', 'Prob_symmetric_chi' ...
        'Gower','Intersection', 'Motyka', 'Cosine', 'Matusita', 'Bhattacharyya', 'Czekanowski', 'Jansen_shannon', 'Emanon4' ...
        'InnerProduct', 'HarmonicMean', 'Fidelity', 'KumarHassebrook'];
    
    addpath(genpath('distancemeasures/.'));
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018-NEW/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);

    Results = zeros(length(Datasets),6);
    
    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    disp(['Dataset being processed: ', char(Datasets(i))]);
                    DS = LoadUCRdataset(char(Datasets(i)));

                    if DistanceIndex>=46
                        [acc,issues,zerodistances,nandistances,infdistances,complexdistances] = OneNNClassifierSimilarity(DS, DistanceIndex);
                    else
                        [acc,issues,zerodistances,nandistances,infdistances,complexdistances] = OneNNClassifierDissimilarity(DS, DistanceIndex);
                    end
                    
                    Results(i,1) = acc;
                    Results(i,2) = issues;
                    Results(i,3) = zerodistances;
                    Results(i,4) = nandistances;
                    Results(i,5) = infdistances;
                    Results(i,6) = complexdistances;
   
            end
            % z-normalization
            dlmwrite( strcat('RESULTS_RunOneNNClassifier_', char(Methods(DistanceIndex)), '_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results, 'delimiter', ',');
            % MinMax-normalization
            dlmwrite( strcat('RESULTS_RunOneNNClassifier_MinMaxNorm_', char(Methods(DistanceIndex)), '_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results, 'delimiter', ',');
            % Scale-normalization
            dlmwrite( strcat('RESULTS_RunOneNNClassifier_ScaleNorm_', char(Methods(DistanceIndex)), '_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results, 'delimiter', ',');
            % Sigmoid-normalization
            dlmwrite( strcat('RESULTS_RunOneNNClassifier_Sigmoid_', char(Methods(DistanceIndex)), '_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results, 'delimiter', ',');
            
    
    
    end
    
end


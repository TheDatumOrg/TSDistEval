function CollectStatistics2(DataSetStartIndex, DataSetEndIndex)  

    Normalizations = [cellstr('ZScoreNorm'), 'MinMaxNorm', 'UnitLengthNorm', 'MeanNorm', 'MedianNorm', 'AdaptiveNorm' ...
        'Sigmoid', 'Tanh'];
    
    Methods = [cellstr('ED'), 'SQRTED', 'DISSIM', 'Manhattan', 'Jaccard', 'Dice', 'AVG_l1_linf', 'Lorentzian' ...
        'Chebyshev', 'Hellinger', 'KumarJohnson', 'Divergence', 'Emanon2', 'Emanon3', 'Clark', 'Soergel' ...
        'Canberra', 'Additive_symm_chi', 'Squared_chi', 'Max_symmetric_chi', 'Min_symmetric_chi' ...
        'Kulczynski', 'Tanimoto', 'Wavehedges', 'Taneja', 'Topsoe', 'Vicis_wave_hedges', 'Square_chord', 'Kullback' ...
        'Neyman', 'K_divergence', 'Jeffrey', 'Jensen_difference', 'Pearson', 'Sorensen', 'Prob_symmetric_chi' ...
        'Gower','Intersection', 'Motyka', 'Cosine', 'Matusita', 'Bhattacharyya', 'Czekanowski', 'Jansen_shannon', 'Emanon4', 'PairWiseScalingDistance' ...
        'InnerProduct', 'HarmonicMean', 'Fidelity', 'KumarHassebrook'];

    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018-NEW/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);
    
    for w = 1:length(Normalizations)
        Results = [];
        for k = 1:length(Methods)
            ResultsTmp = dlmread( strcat('./RESULTS/RESULTS_RunONNC_ACCURACY_', char(Methods(k)), '_', char(Normalizations(w)), '_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)) );
            Results = [Results;ResultsTmp];        
        end
        dlmwrite( strcat( './RESULTSFINAL_RunONNC_ACCURACY_', char(Normalizations(w)),'_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results, 'delimiter', ',');
    
    end
    
end

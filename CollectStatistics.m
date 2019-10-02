function CollectStatistics(DataSetStartIndex, DataSetEndIndex, DistanceIndex)  

    Methods = [cellstr('ED'), 'SBD', 'MSM', 'DTW', 'EDR', 'SINK', 'GAK', 'LCSS', 'TWED', 'DISSIM', 'TQuEST', 'Swale'];

    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);
    
    %FourierEnergy = 1;
    %DatasetPercentile = 100;
    
    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    disp(['Dataset being processed: ', char(Datasets(i))]);
                    %DS = LoadUCRdataset(char(Datasets(i)));
                    %disp([char(Datasets(i)),',',num2str(length(DS.ClassNames)),',',num2str(DS.TrainInstancesCount),',',num2str(DS.TestInstancesCount),',',num2str(length(DS.Train(1,:)))]);
                    
                    ResultsTmp = dlmread( strcat('./RunOneNNWITHDM/', 'RESULTS_RunOneNNWITHDM_', char(Methods(DistanceIndex)),'_', num2str(i)) );
                    
                    %ResultsTmp = dlmread( strcat( 'RunClassificationZREP/RunClassificationZREP_FULLKM_Z20_KShape_', num2str(i),'.results') );
                    %ResultsTmp = dlmread( strcat('RunOneNNTOPFFTED/', 'RunOneNNTOPFFTED_Dataset_', num2str(i), '_NumOfCoeff_',num2str(10)) );
                                        
                    Results(i,:) = ResultsTmp(i,:);
                    
            end
                    
           
    end
            
    dlmwrite( strcat( './RESULTS_RunOneNNWITHDM_', char(Methods(DistanceIndex)),'_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results, 'delimiter', ',');
    
    %dlmwrite( strcat( '/rigel/dsi/users/ikp2103/JOPA/GRAIL2/RESULTS/RunOneNNTOPFFTED_NumOfCoeff_10_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex)), Results, 'delimiter', ',');
    
end

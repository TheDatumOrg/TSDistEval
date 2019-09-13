function RunDMComp(DataSetStartIndex, DataSetEndIndex, DistanceIndex, Param1)

    % Distance Matrices for ED and SBD
    Methods = [cellstr('ED'), 'SBD', 'MSM', 'DTW', 'EDR'];

    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018-NEW/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, ~] = sort(Datasets);

    poolobj = gcp('nocreate');
    delete(poolobj);
    
    parpool(18);
    
    for i = 1:length(Datasets)
        
        if (i>=DataSetStartIndex && i<=DataSetEndIndex)

            disp(['Dataset being processed: ', char(Datasets(i))]);
            DS = LoadUCRdataset(char(Datasets(i)));
            
            DM = DMComp(DS.Data, DistanceIndex, Param1);

            dlmwrite( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '.distmatrix' ), DM, 'delimiter', ',');

        end
        
    end
    
    poolobj = gcp('nocreate');
    delete(poolobj);

end
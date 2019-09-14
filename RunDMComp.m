function RunDMComp(DataSetStartIndex, DataSetEndIndex, DistanceIndex, Param1, Param2)

    % Distance Matrices for ED and SBD
    Methods = [cellstr('ED'), 'SBD', 'MSM', 'DTW', 'EDR', 'SINK', 'GAK'];

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
            
            % For GAK Kernel bandwidth, 26 overall
            % 1-20, 0.01 0.05 0.1 0.25 0.5 0.75
            Params = [0.01,0.05,0.1,0.25,0.5,0.75,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            
            for w=Param1:Param2
            DM = DMComp(DS.Data, DistanceIndex, Params(w));

            dlmwrite( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)), '.distmatrix' ), DM, 'delimiter', ',');
            end
            
            %DM = DMComp(DS.Data, DistanceIndex, Param1);

            %dlmwrite( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '.distmatrix' ), DM, 'delimiter', ',');
 
        end
        
    end
    
    poolobj = gcp('nocreate');
    delete(poolobj);

end
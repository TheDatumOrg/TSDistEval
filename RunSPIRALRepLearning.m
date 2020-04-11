function RunSPIRALRepLearning(DataSetStartIndex, DataSetEndIndex)  
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);  
    
    addpath(genpath('SPIRAL/.'));
    
    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    display(['Dataset being processed: ', char(Datasets(i))]);
                    DS = LoadUCRdataset(char(Datasets(i)));
                    
                    NumOfSamples = min(max( [4*length(DS.ClassNames), ceil(0.4*DS.DataInstancesCount),20] ),100);
                    
                    tic;
                    ZRep = SPIRALRepLearning(DS, NumOfSamples); 
                    RTResult = toc;
                    
                    dlmwrite( strcat( 'SPIRALREPRESENTATIONS','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '.Zrep'), ZRep, 'delimiter', '\t');
                    dlmwrite( strcat( 'SPIRALREPRESENTATIONS-RT','/',char(Datasets(i)),'/','SIDLREPRESENTATIONS', '.RT'), RTResult, 'delimiter', '\t');
                                   
                                    
            end
            
            
    end
    
    
end

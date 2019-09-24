function RunOneNNED(DataSetStartIndex, DataSetEndIndex)  
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018-NEW/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);

    Results = zeros(length(Datasets),2);
    
    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    disp(['Dataset being processed: ', char(Datasets(i))]);
                    %DS = LoadUCRdataset(char(Datasets(i)));
                    DS = LoadOtherdatasetLocal(char(Datasets(i)));
                    
                    tic;
                    OneNNAcc = OneNNClassifierED(DS);
                    
                    Results(i,1) = OneNNAcc;
                    Results(i,2) = toc;
   
                    
   
            end
            dlmwrite( strcat('./', 'RunOneNNED_Dataset_', num2str(128)), Results, 'delimiter', ',');
            
    end
    
end


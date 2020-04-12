function RunRWSRepLearning(DataSetStartIndex, DataSetEndIndex, sigma)  
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);  
    
    addpath(genpath('RWS/.'));
    addpath(genpath('RWS/utilities/.'));
    
    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    display(['Dataset being processed: ', char(Datasets(i))]);
                    DS = LoadUCRdataset(char(Datasets(i)));
                    
                    NumOfSamples = min(max( [4*length(DS.ClassNames), ceil(0.4*DS.DataInstancesCount),20] ),100);

                    %ZRep = SPIRALRepLearning(DS, NumOfSamples); 

                    %DMin = 1;
                    %DMax_list = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100];
                    %sigma_list = [1e-3 3e-3 1e-2 3e-2 0.10 0.14 0.19 0.28 0.39 0.56 ...
                    %0.79 1.12 1.58 2.23 3.16 4.46 6.30 8.91 10 31.62 1e2 3e2 1e3];

                    % Supervised Tuning
                    %info = RWSTuneParameters(DS,NumOfSamples);
                    %ZRepSup = RWSRepLearning(DS,info.sigma,NumOfSamples,1,info.DMax);
                    
                    tic;
                    % Without Tuning for Clustering
                    ZRepUNSup = RWSRepLearning(DS,sigma,NumOfSamples,1,100);
                    %ZRepUNSup = RWSRepLearning(DS,1000,NumOfSamples,1,25);
                    
                    RTResult = toc;
                    %dlmwrite( strcat( 'RWSREPRESENTATIONS','/',char(Datasets(i)),'/','RWS_Supervised', '.Zrep'), ZRepSup, 'delimiter', '\t');
                    
                    dlmwrite( strcat( 'RWSREPRESENTATIONS','/',char(Datasets(i)),'/','RWS_UNSupervised_Sigma_',num2str(sigma),'_DMax100', '.Zrep'), ZRepUNSup, 'delimiter', '\t');
                    dlmwrite( strcat( 'RWSREPRESENTATIONS-RT','/',char(Datasets(i)),'/','RWS_UNSupervised_Sigma_',num2str(sigma),'_DMax100', '.RT'), RTResult, 'delimiter', '\t');
                           
                                   
                                    
            end
            
            
    end
    
    
end

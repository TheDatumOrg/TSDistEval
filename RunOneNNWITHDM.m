function RunOneNNWITHDM(DataSetStartIndex, DataSetEndIndex, DistanceIndex)  
    
    Methods = [cellstr('ED'), 'SBD', 'MSM', 'DTW', 'EDR', 'SINK', 'GAK', 'LCSS', 'TWED', 'DISSIM', 'TQuEST', 'Swale'];

    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018-NEW/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets    
    [Datasets, DSOrder] = sort(Datasets);
        
    %LeaveOneOutAccuracies = zeros(length(Datasets),20);
    %LeaveOneOutRuntimes = zeros(length(Datasets),20);
    
    Results = zeros(length(Datasets),4);

    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    disp(['Dataset being processed: ', char(Datasets(i))]);
                    DS = LoadUCRdataset(char(Datasets(i)));
                    
                    % Parameters based on DistanceIndex choice
                    [Params, Params2]= DistanceToParameter(DistanceIndex);
                    

                    bestParam1=0;
                    bestParam2=0;
                    bestacc = 0;
                    for w=1:length(Params)
                        for wprime = 1:length(Params2)
                            [DMTRAIN,~] = DistanceToDM(DistanceIndex,Datasets,i,Methods, Params(w), Params2(wprime));
                             acc = LOOCWITHDM(DS, DMTRAIN);
                             if acc>=bestacc
                                bestacc = acc;
                                bestParam1=Params(w);
                                bestParam2=Params2(wprime);
                            end
                        end 
                    end
                    

                    [~,DMTESTTOTRAIN] = DistanceToDM(DistanceIndex,Datasets,i,Methods, bestParam1, bestParam2);

                    OneNNAcc = OneNNClassifierWITHKM(DS, DMTESTTOTRAIN);
                    
                    Results(i,1) = bestParam1;
                    Results(i,2) = bestParam2;
                    Results(i,3) = bestacc;
                    Results(i,4) = OneNNAcc;
   
                    dlmwrite( strcat('./RunOneNNWITHDM/', 'RESULTS_RunOneNNWITHDM_', char(Methods(DistanceIndex)),'_', num2str(i)), Results, 'delimiter', '\t');
   
            end
            
            
    end
    
end


function [DMTRAIN,DMTESTTOTRAIN] = DistanceToDM(DistanceIndex,Datasets,i,Methods, Param1, Param2)

            if DistanceIndex==1
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_TrainToTest.distmatrix' ) );
            elseif DistanceIndex==2
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_TrainToTest.distmatrix' ) );
            elseif DistanceIndex==3
                    % MSM - 10 Parameters
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_TrainToTest.distmatrix' ) );
            elseif DistanceIndex==4
                    % DTW - 0-20, 100 - 22 Parameters
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_TrainToTest.distmatrix' ) );
            elseif DistanceIndex==5
                    % EDR - 20 Parameters
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_TrainToTest.distmatrix' ) );
            elseif DistanceIndex==6
                    % SINK
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_TrainToTest.distmatrix' ) ); 
            elseif DistanceIndex==7
                    % For GAK Kernel bandwidth, 26 overall
                    % 1-20, 0.01 0.05 0.1 0.25 0.5 0.75
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1), '_TrainToTest.distmatrix' ) );
            elseif DistanceIndex==8
                    % For LCSS delta and espilon, 40 overall
                    % 
                    % delta
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TrainToTest.distmatrix' ) );                  
            elseif DistanceIndex==9
                    % For TWED lambda and nu, 30 overall
                    % 
                    % lambda
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TrainToTest.distmatrix' ) );
            elseif DistanceIndex==10
                    % For DISSIM
                    % 
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TrainToTest.distmatrix' ) );
            elseif DistanceIndex==11
                    % For TQUEST
                    % 
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TrainToTest.distmatrix' ) );      
            elseif DistanceIndex==12
                    % For Swale
                    % 
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TrainToTest.distmatrix' ) );     
            end

end


function [Params,Params2] = DistanceToParameter(DistanceIndex)

            if DistanceIndex==1
                    Params = 0;
            elseif DistanceIndex==2
                    Params = 0;
            elseif DistanceIndex==3
                    % MSM - 10 Parameters
                    Params = [0.01,0.1,1,10,100,0.05,0.5,5,50,500];
            elseif DistanceIndex==4
                    % DTW - 0-20, 100 - 22 Parameters
                    Params = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,100];  
            elseif DistanceIndex==5
                    % EDR - 20 Parameters
                    Params = [0.001,0.003,0.005,0.007,0.009,0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];  
            elseif DistanceIndex==6
                    % SINK
                    Params = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];  
            elseif DistanceIndex==7
                    % For GAK Kernel bandwidth, 26 overall
                    % 1-20, 0.01 0.05 0.1 0.25 0.5 0.75
                    Params = [0.01,0.05,0.1,0.25,0.5,0.75,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
            elseif DistanceIndex==8
                    % For LCSS delta and espilon, 40 overall
                    % 
                    % delta
                    Params = [5,10];
                    % epsilon
                    Params2 = [0.001,0.003,0.005,0.007,0.009,0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
                    
            elseif DistanceIndex==9
                    % For TWED lambda and nu, 30 overall
                    % 
                    % lambda
                    Params = [0, 0.25, 0.5, 0.75, 1.0];
                    % nu
                    Params2 = [0.00001, 0.0001, 0.001, 0.01, 0.1, 1];
            elseif DistanceIndex==10
                    % For DISSIM
                    % 
                    Params = 0;
                    Params2 = 0;
            elseif DistanceIndex==11
                    % For TQUEST
                    % 
                    Params = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
                    Params2 = 0;        
            elseif DistanceIndex==12
                    % For Swale
                    % 
                    Params = [0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
                    Params2 = 0;          
            end


end
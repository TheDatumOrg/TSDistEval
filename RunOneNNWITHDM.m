function RunOneNNWITHDM(DataSetStartIndex, DataSetEndIndex, DistanceIndex)  

    Methods = [cellstr('ED'), 'SBD', 'MSM', 'DTW', 'EDR', 'SINK', 'GAK', 'LCSS', 'TWE', 'DISSIM', 'TQuEST', 'Swale', 'KDTW', 'ERP' ];
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets    
    [Datasets, DSOrder] = sort(Datasets);
        
    %LeaveOneOutAccuracies = zeros(length(Datasets),20);
    %LeaveOneOutRuntimes = zeros(length(Datasets),20);
    
    %Results = zeros(length(Datasets),4);

    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                Results = zeros(length(Datasets),4);

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

                    OneNNAcc = OneNNClassifierWITHDM(DS, DMTESTTOTRAIN);
                    
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
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==2
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==3
                    % MSM - 10 Parameters
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==4
                    % DTW - 0-20, 100 - 22 Parameters
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==5
                    % EDR - 20 Parameters
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==6
                    % SINK
                    DMTRAIN = dlmread( strcat( './KM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) ); 
            elseif DistanceIndex==7
                    % For GAK Kernel bandwidth, 26 overall
                    % 1-20, 0.01 0.05 0.1 0.25 0.5 0.75
                    DMTRAIN = dlmread( strcat( './KM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==8
                    % For LCSS delta and espilon, 40 overall
                    % 
                    % delta
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );                  
            elseif DistanceIndex==9
                    % For TWED lambda and nu, 30 overall
                    % 
                    % lambda
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==10
                    % For DISSIM
                    % 
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==11
                    % For TQUEST
                    % 
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );      
            elseif DistanceIndex==12
                    % For Swale
                    % 
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );     
            elseif DistanceIndex==13
                    % For KDTW
                    % 
                    DMTRAIN = dlmread( strcat( './KM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );     
            elseif DistanceIndex==14
                    % For ERP
                    % 
                    DMTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );     
            
            
            
            end

end


function [Params,Params2] = DistanceToParameter(DistanceIndex)

            if DistanceIndex==1
                    Params = 0;
                    Params2 = 0;
            elseif DistanceIndex==2
                    Params = 0;
                    Params2 = 0;
            elseif DistanceIndex==3
                    % MSM - 10 Parameters
                    %Params = [0.01,0.1,1,10,100,0.05,0.5,5,50,500];
                    Params = 1;
                    Params2 = 0;
            elseif DistanceIndex==4
                    % DTW - 0-20, 100 - 22 Parameters
                    %Params = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,100];
                    Params = 5;
                    Params2 = 0;
            elseif DistanceIndex==5
                    % EDR - 20 Parameters
                    %Params = [0.001,0.003,0.005,0.007,0.009,0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]; 
                    Params = 0.05; 
                    Params2 = 0;
            elseif DistanceIndex==6
                    % SINK
                    %Params = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]; 
                    Params = 20; 
                    Params2 = 0;
            elseif DistanceIndex==7
                    % For GAK Kernel bandwidth, 26 overall
                    % 1-20, 0.01 0.05 0.1 0.25 0.5 0.75
                    %Params = [0.01,0.05,0.1,0.25,0.5,0.75,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
                    Params = 0.1;
                    Params2 = 0;
            elseif DistanceIndex==8
                    % For LCSS delta and espilon, 40 overall
                    % 
                    % delta
                    %Params = [5,10];
                    Params = 5;
                    % epsilon
                    %Params2 = [0.001,0.003,0.005,0.007,0.009,0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
                    Params2 = [0.1];
                    
            elseif DistanceIndex==9
                    % For TWED lambda and nu, 30 overall
                    % 
                    % lambda
                    %Params = [0, 0.25, 0.5, 0.75, 1.0];
                    Params = [1.0];
                    % nu
                    %Params2 = [0.00001, 0.0001, 0.001, 0.01, 0.1, 1];
                    Params2 = [0.001];
            elseif DistanceIndex==10
                    % For DISSIM
                    % 
                    Params = 0;
                    Params2 = 0;
            elseif DistanceIndex==11
                    % For TQUEST
                    % 
                    %Params = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,2];
                    Params = [0.0200000000000000,0.0400000000000000,0.0600000000000000,0.0800000000000000,0.100000000000000,0.120000000000000,0.140000000000000,0.160000000000000,0.180000000000000,0.200000000000000,0.220000000000000,0.240000000000000,0.260000000000000,0.280000000000000,0.300000000000000,0.320000000000000,0.340000000000000,0.360000000000000,0.380000000000000,0.400000000000000,0.420000000000000,0.440000000000000,0.460000000000000,0.480000000000000,0.500000000000000,0.520000000000000,0.540000000000000,0.560000000000000,0.580000000000000,0.600000000000000,0.620000000000000,0.640000000000000,0.660000000000000,0.680000000000000,0.700000000000000,0.720000000000000,0.740000000000000,0.760000000000000,0.780000000000000,0.800000000000000,0.820000000000000,0.840000000000000,0.860000000000000,0.880000000000000,0.900000000000000,0.920000000000000,0.940000000000000,0.960000000000000,0.980000000000000,1];
                    Params2 = 0;        
            elseif DistanceIndex==12
                    % For Swale
                    % 
                    %Params = [0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
                    Params = 0.1;
                    Params2 = 0;             
            elseif DistanceIndex==13
                    % For KDTW
                    % 
                    %Params = [2^-15,2^-14,2^-13,2^-12,2^-11,2^-10,2^-9,2^-8,2^-7,2^-6,2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4];
                    %Params = [2^-15,2^-14,2^-13,2^-12,2^-11,2^-10,2^-9,2^-8,2^-7,2^-6,2^-5,2^-4,2^-3];
                    Params = 2^-5;
                    Params2 = 0; 
            elseif DistanceIndex==14
                    % For ERP
                    % 
                    Params = 0;
                    Params2 = 0; 
            end


end
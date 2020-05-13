function RunOneNNWITHDMNEWKERNELS(DataSetStartIndex, DataSetEndIndex, DistanceIndex)  

    % Kernel Matrices for:
    % 1 - LinearNCCc             0 Parameters (1 x 1)
    % 2 - GaussianNCCc           10 Parameters (10 x 1)
    % 3 - LogKernelNCCc          5 Parameters (5 x 1)
    % 4 - LogisticKernelNCCc     0 Parameters (1 x 1)
    % 5 - PolynomialNCCc         12 Parameters (4 x 3)
    % 6 - TanhNCCc               5 Parameters (5 x 1)
    % 7 - MultiQuadNCCc          5 Parameters (5 x 1)
    % 8 - RationalQuadNCCc       5 Parameters (5 x 1)
    % 9 - InverseMultiQuadNCCc   5 Parameters (5 x 1)
    % 10 - CauchyKernelNCCc      5 Parameters (5 x 1)
    %
    Methods = [cellstr('LinearNCCc'), 'GaussianNCCc', 'LogKernelNCCc', 'LogisticKernelNCCc', 'PolynomialNCCc', ... 
        'TanhNCCc', 'MultiQuadNCCc', 'RationalQuadNCCc', 'InverseMultiQuadNCCc', 'CauchyKernelNCCc'];

    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018');
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
                    
                    % RBF from ED
                    %Params = [2^-20,2^-19,2^-18,2^-17,2^-16,2^-15,2^-14,2^-13,2^-12,2^-11,2^-10,2^-9,2^-8,2^-7,2^-6,2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1];
                    %Params = [2^1];
                    bestParam1=0;
                    bestParam2=0;
                    bestacc = 0;
                    for w=1:length(Params)
                        for wprime = 1:length(Params2)
                            [DMTRAIN,~] = DistanceToDM(DistanceIndex,Datasets,i,Methods, Params(w), Params2(wprime));
                            %[DMTRAIN,~] = DistanceToDM(DistanceIndex,Datasets,i,Methods, 0, 0);
                            %DMTRAIN = DM2KM(DMTRAIN, Params(w));
                             acc = LOOCWITHDM(DS, DMTRAIN);
                             if acc>=bestacc
                                bestacc = acc;
                                bestParam1=Params(w);
                                bestParam2=Params2(wprime);
                            end
                        end 
                    end
                    

                    [~,DMTESTTOTRAIN] = DistanceToDM(DistanceIndex,Datasets,i,Methods, bestParam1, bestParam2);
                    %DMTESTTOTRAIN = DM2KM(DMTESTTOTRAIN, bestParam1);
                    
                    OneNNAcc = OneNNClassifierWITHDM(DS, DMTESTTOTRAIN);
                    
                    Results(i,1) = bestParam1;
                    Results(i,2) = bestParam2;
                    Results(i,3) = bestacc;
                    Results(i,4) = OneNNAcc;
   
                    %dlmwrite( strcat('./RunOneNNWITHDMNEWKERNELS/', 'RESULTS_RunOneNNWITHDM_', char(Methods(DistanceIndex)),'_', num2str(i)), Results, 'delimiter', '\t');
   
            end
            
            dlmwrite( strcat('RESULTS_RunOneNNWITHDMNEWKERNELS_', char(Methods(DistanceIndex))), Results, 'delimiter', '\t');
   
    end
    
end


function [DMTRAIN,DMTESTTOTRAIN] = DistanceToDM(DistanceIndex,Datasets,i,Methods, Param1, Param2)

            if DistanceIndex==1
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==2
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==3
                    % MSM - 10 Parameters
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==4
                    % DTW - 0-20, 100 - 22 Parameters
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==5
                    % EDR - 20 Parameters
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==6
                    % SINK
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) ); 
            elseif DistanceIndex==7
                    % For GAK Kernel bandwidth, 26 overall
                    % 1-20, 0.01 0.05 0.1 0.25 0.5 0.75
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_',num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==8
                    % For LCSS delta and espilon, 40 overall
                    % 
                    % delta
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );                  
            elseif DistanceIndex==9
                    % For TWED lambda and nu, 30 overall
                    % 
                    % lambda
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==10
                    % For DISSIM
                    % 
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );
            elseif DistanceIndex==11
                    % For TQUEST
                    % 
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );      
            elseif DistanceIndex==12
                    % For Swale
                    % 
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );     
            elseif DistanceIndex==13
                    % For KDTW
                    % 
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );     
            elseif DistanceIndex==14
                    % For ERP
                    % 
                    DMTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_Train.distmatrix' ) );
                    DMTESTTOTRAIN = dlmread( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Param1),'_', num2str(Param2), '_TestToTrain.distmatrix' ) );     
            
            end

end


function [Params,Params2] = DistanceToParameter(DistanceIndex)


            if DistanceIndex==1
                    % 1 - LinearNCCc             0 Parameters (1 x 1)
                    Params = 0;  
                    Params2 = 0; 
            elseif DistanceIndex==2
                    % 2 - GaussianNCCc           10 Parameters (10 x 1)
                    Params = [1,3,5,7,9,11,13,15,17,19];
                    Params2 = 0; 
            elseif DistanceIndex==3
                    % 3 - LogKernelNCCc          5 Parameters (5 x 1)
                    Params = [2,4,6,8,10];
                    Params2 = 0; 
            elseif DistanceIndex==4
                    % 4 - LogisticKernelNCCc     0 Parameters (1 x 1)
                    Params = 0;
                    Params2 = 0; 
            elseif DistanceIndex==5
                    % 5 - PolynomialNCCc         12 Parameters (4 x 3)
                    Params = [1,5,10,20];
                    Params2 = [2,4,6]; 
            elseif DistanceIndex==6
                    % 6 - TanhNCCc               5 Parameters (5 x 1)
                    Params = [1,5,10,15,20];
                    Params2 = 0; 
            elseif DistanceIndex==7
                    % 7 - MultiQuadNCCc          5 Parameters (5 x 1)
                    Params = [1,5,10,15,20];
                    Params2 = 0; 
            elseif DistanceIndex==8
                    % 8 - RationalQuadNCCc       5 Parameters (5 x 1)
                    Params = [1,5,10,15,20];
                    Params2 = 0; 
            elseif DistanceIndex==9
                    % 9 - InverseMultiQuadNCCc   5 Parameters (5 x 1)
                    Params = [1,5,10,15,20];
                    Params2 = 0; 
            elseif DistanceIndex==10
                    % 10 - CauchyKernelNCCc      5 Parameters (5 x 1)
                    Params = [1,5,10,15,20];
                    Params2 = 0; 
            end


end
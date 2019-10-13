function RunOneNNTunedNormalizations(DataSetStartIndex, DataSetEndIndex, NormalizationIndex)  

    % Normalization
    % 1 - MinMaxNorm
    % 2 - SlidingZScore
    
    Normalizations = [cellstr('MinMaxTuned'), 'SlidingZScore'];
    
    addpath(genpath('normalizations/.'));
    
    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018-NEW/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, DSOrder] = sort(Datasets);  
    
    addpath(genpath('distancemeasures/.'));

    Results = zeros(length(Datasets),3);

    for i = 1:length(Datasets)

            if (i>=DataSetStartIndex && i<=DataSetEndIndex)

                    LeaveOneOutAccuracies = zeros(length(Datasets),25);
                    LeaveOneOutRuntimes = zeros(length(Datasets),25);

                    disp(['Dataset being processed: ', char(Datasets(i))]);
                    DS = LoadUCRdataset(char(Datasets(i)));
                    
                    
                    
                    for gammaIter = 1:20

                        gammaIter
                        

                        if NormalizationIndex==1
                            gammaValues = 0.75:0.025:1.25;
                            tic;
                            acc = LOOCTunedNormalizations(DS, NormalizationIndex, gammaValues(gammaIter));
                            LeaveOneOutRuntimes(i,gammaIter) = toc;
                            LeaveOneOutAccuracies(i,gammaIter) = acc;
                        elseif NormalizationIndex==2
                            gammaValues = [5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100];
                            tic;
                            acc = LOOCTunedNormalizations(DS, NormalizationIndex, floor(gammaValues(gammaIter)/100 * length(DS.Train(1,:))));
                            LeaveOneOutRuntimes(i,gammaIter) = toc;
                            LeaveOneOutAccuracies(i,gammaIter) = acc;
                        end

                    end
                    
                    [MaxLeaveOneOutAcc,MaxLeaveOneOutAccGamma] = max(LeaveOneOutAccuracies(i,:));

                    OneNNAcc = OneNNClassifierTunedNormalizations(DS, NormalizationIndex, gammaValues(MaxLeaveOneOutAccGamma));
                                 
                    Results(i,1) = gammaValues(MaxLeaveOneOutAccGamma);
                    Results(i,2) = MaxLeaveOneOutAcc;
                    Results(i,3) = OneNNAcc;
                    
                    
            end
            dlmwrite( strcat('RESULTS_RunOneNNTunedNormalizations_ED_', char(Normalizations(NormalizationIndex)), '_', num2str(DataSetStartIndex), '_', num2str(DataSetEndIndex) ), Results, 'delimiter', '\t');
   
            
    end
    
end
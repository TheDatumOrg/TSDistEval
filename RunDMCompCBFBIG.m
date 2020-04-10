function RunDMCompCBFBIG(DataSetStartIndex, DataSetEndIndex, DistanceIndex, Param1, Param2, Param1prime, Param2prime, Train, Test)

    % Distance Matrices for:
    % 1 - ED            1 Empty Parameter
    % 2 - SBD           1 Empty Parameter
    % 3 - MSM           10 Parameters (10 x 1)
    % 4 - DTW           22 Parameters (22 x 1)
    % 5 - EDR           20 Parameters (20 x 1)
    % 6 - LCSS          40 Parameters (2 x 20)
    % 7 - TWE           30 Parameters (5 x 6)
    % 8 - Swale         15 Parameters (15 x 1)
    % 9 - ERP           2 Empty Parameters
    Methods = [cellstr('Lorentzian'), 'SBD', 'MSM', 'DTW', 'EDR', 'LCSS', 'TWE', 'Swale', 'ERP'];

    Datasets = [cellstr('CBFBIG')];
    
    % Sort Datasets
    
    [Datasets, ~] = sort(Datasets);
    
    %poolobj = gcp('nocreate');
    %delete(poolobj);
    
    %parpool(18);
    
    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('slidingmeasures/.'));
    addpath(genpath('elasticmeasures/.'));
    
    for i = 1:length(Datasets)
        
        if (i>=DataSetStartIndex && i<=DataSetEndIndex)

            disp(['Dataset being processed: ', char(Datasets(i))]);
            DS = LoadCBFBIGdataset(char(Datasets(i)));
            
            [Params, Params2]= DistanceToParameter(DistanceIndex);

            for w=Param1:Param2
                for wprime = Param1prime:Param2prime
                disp(w);
                disp(wprime);
                
                [NewParameter1, NewParameter2] = ComputeParameters(DS.Train, DistanceIndex, Params(w), Params2(wprime));
                
                if Train==1
                    tic;
                    DM1 = DMComp(DS.Train, DistanceIndex, NewParameter1, NewParameter2);
                    RT1 = toc;

                    dlmwrite( strcat( './DMCBFBIG/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '_Train.distmatrix' ), DM1, 'delimiter', ',');

                    dlmwrite( strcat( './DMCBFBIG-Runtime/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '.rtTrain' ), RT1, 'delimiter', ',');

                end
                
                if Test==1
                    tic;
                    DM2 = DMComp_TestToTrain(DS.Test, DS.Train, DistanceIndex, NewParameter1, NewParameter2);
                    RT2 = toc;

                    dlmwrite( strcat( './DMCBFBIG/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '_TestToTrain.distmatrix' ), DM2, 'delimiter', ',');

                    dlmwrite( strcat( './DMCBFBIG-Runtime/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '.rtTestToTrain' ), RT2, 'delimiter', ',');

                end
                
                end
            end
            

        end
        
    end
    
    %poolobj = gcp('nocreate');
    %delete(poolobj);

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
                    Params = [0.01,0.1,1,10,100,0.05,0.5,5,50,500];
                    Params2 = 0; 
            elseif DistanceIndex==4
                    % DTW - 0-20, 100 - 22 Parameters
                    Params = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,100];  
                    Params2 = 0; 
            elseif DistanceIndex==5
                    % EDR - 20 Parameters
                    Params = [0.001,0.003,0.005,0.007,0.009,0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];  
                    Params2 = 0; 
            elseif DistanceIndex==6
                    % For LCSS delta and espilon, 40 overall
                    % 
                    % delta
                    Params = [5,10];
                    %Params = 5;
                    % epsilon
                    Params2 = [0.001,0.003,0.005,0.007,0.009,0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];                    
            elseif DistanceIndex==7
                    % For TWE lambda and nu, 30 overall
                    % 
                    % lambda
                    Params = [0, 0.25, 0.5, 0.75, 1.0];
                    % nu
                    Params2 = [0.00001, 0.0001, 0.001, 0.01, 0.1, 1];
            elseif DistanceIndex==8
                    % For Swale
                    % 
                    Params = [0.01,0.03,0.05,0.07,0.09,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
                    Params2 = 0; 
            elseif DistanceIndex==9
                    % For ERP
                    % 
                    Params = 0;
                    Params2 = 0; 
            end


end

function [NewParameter1, NewParameter2] = ComputeParameters(X, DistanceIndex, Parameter1, Parameter2)

    [m, TSLength] = size(X);

    if DistanceIndex==4             
        % DTW warping window
        NewParameter1 = floor(Parameter1/100 * TSLength); 
        NewParameter2 = Parameter2;        
    elseif DistanceIndex==6
        % LCSS 
        NewParameter1 = floor(Parameter1/100 * TSLength); 
        NewParameter2 = Parameter2; 
    else
        NewParameter1 = Parameter1;
        NewParameter2 = Parameter2;
    end

end



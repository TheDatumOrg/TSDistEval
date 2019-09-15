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
            
            Params = DistanceToParameter(DistanceIndex);

            for w=Param1:Param2
                disp(w);
                
                NewParameter = ComputeParameters(DS.Train, DistanceIndex, Params(w));
                
                DM1 = DMComp(DS.Train, DistanceIndex, NewParameter);

                dlmwrite( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)), 'Train.distmatrix' ), DM1, 'delimiter', ',');
                
                DM2 = DMComp_TestToTrain(DS.Test, DS.Train, DistanceIndex, NewParameter);

                dlmwrite( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)), 'TrainToTest.distmatrix' ), DM2, 'delimiter', ',');
 
            end
            

        end
        
    end
    
    poolobj = gcp('nocreate');
    delete(poolobj);

end

function Params = DistanceToParameter(DistanceIndex)

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
            end


end

function NewParameter = ComputeParameters(X, DistanceIndex, Parameter1)

    [m, TSLength] = size(X);

    if DistanceIndex==4             
        % DTW warping window
        NewParameter = floor(Parameter1/100 * TSLength); 
        
    elseif DistanceIndex==7
        % GAK warping window
        dists = [];
        for l=1:5
             rng(l);
             x = X(ceil(rand*m),:);
             y = X(ceil(rand*m),:);
             w = [];
             for p=1:TSLength
                 w(p)= ED(x(p),y(p));
             end
             dists=[dists,w];
        end

        NewParameter = Parameter1*median(dists)*sqrt(TSLength);      
    else
        NewParameter = Parameter1;
    end

end



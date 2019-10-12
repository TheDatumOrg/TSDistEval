function RunDMComp(DataSetStartIndex, DataSetEndIndex, DistanceIndex, Param1, Param2, Param1prime, Param2prime)

    % Distance Matrices for ED and SBD
    % 1 - ED            1 Empty Parameter  DONE
    % 2 - SBD           1 Empty Parameter  DONE
    % 3 - MSM           10 Parameters      DONE
    % 4 - DTW           22 Parameters      DONE
    % 5 - EDR           20 Parameters      DONE
    % 6 - SINK          20 Parameters      DONE
    % 7 - GAK           26 Parameters      DONE
    % 8 - LCSS          40 Parameters (20 x 2) DONE WITH RUNDM - NO RESULTS
    % 9 - TWED          30 Parameters (5 x 6)  DONE
    % 10 - DISSIM       2 Empty Parameters DONE (Script now has 2 params)
    % 11 - TQuEST       10 Parameters
    % 12 - Swale        15 Parameters      DONE
    % 13 - KDTW         20 Parameters      DONE WITH RUNDM - NO RESULTS
    % 14 - ERP          2 Empty Parameters RUNNING
    Methods = [cellstr('ED'), 'SBD', 'MSM', 'DTW', 'EDR', 'SINK', 'GAK', 'LCSS', 'TWED', 'DISSIM', 'TQuEST', 'Swale', 'KDTW', 'ERP'];

    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018-NEW/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, ~] = sort(Datasets);
    
    %poolobj = gcp('nocreate');
    %delete(poolobj);
    
    %parpool(18);
    
    for i = 1:length(Datasets)
        
        if (i>=DataSetStartIndex && i<=DataSetEndIndex)

            disp(['Dataset being processed: ', char(Datasets(i))]);
            DS = LoadUCRdataset(char(Datasets(i)));
            
            [Params, Params2]= DistanceToParameter(DistanceIndex);

            for w=Param1:Param2
                for wprime = Param1prime:Param2prime
                disp(w);
                disp(wprime);
                
                [NewParameter1, NewParameter2] = ComputeParameters(DS.Train, DistanceIndex, Params(w), Params2(wprime));
                
                DM1 = DMComp(DS.Train, DistanceIndex, NewParameter1, NewParameter2);

                dlmwrite( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '_Train.distmatrix' ), DM1, 'delimiter', ',');
                
                DM2 = DMComp_TestToTrain(DS.Test, DS.Train, DistanceIndex, NewParameter1, NewParameter2);

                dlmwrite( strcat( './DM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '_TrainToTest.distmatrix' ), DM2, 'delimiter', ',');
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
                    %Params = [5,10];
                    Params = [5];
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
            elseif DistanceIndex==13
                    % For KDTW
                    % 
                    Params = [2^-15,2^-14,2^-13,2^-12,2^-11,2^-10,2^-9,2^-8,2^-7,2^-6,2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4];
                    Params2 = 0; 
            elseif DistanceIndex==14
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

        NewParameter1 = Parameter1*median(dists)*sqrt(TSLength);  
        
        
    elseif DistanceIndex==8
        % LCSS 
        NewParameter1 = floor(Parameter1/100 * TSLength); 
        NewParameter2 = Parameter2; 

    else
        NewParameter1 = Parameter1;
        NewParameter2 = Parameter2;
    end

end



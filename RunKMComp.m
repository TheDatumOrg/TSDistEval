function RunKMComp(DataSetStartIndex, DataSetEndIndex, DistanceIndex, Param1, Param2, Param1prime, Param2prime, Train, Test)

    % Kernel Matrices for:
    % 1 - SINK          20 Parameters (20 x 1)
    % 2 - GAK           26 Parameters (26 x 1)
    % 3 - KDTW          20 Parameters (20 x 1)
    %
    %
    Methods = [cellstr('SINK'), 'GAK', 'KDTW'];

    % first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
    dir_struct = dir('./UCR2018/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, ~] = sort(Datasets);
    
    %poolobj = gcp('nocreate');
    %delete(poolobj);
    
    %parpool(18);
    
    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('kernelmeasures/.'));
    
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
                
                if Train==1
                    tic;
                    DM1 = KMComp(DS.Train, DistanceIndex, NewParameter1, NewParameter2);
                    RT1 = toc;

                    dlmwrite( strcat( './KM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '_Train.distmatrix' ), DM1, 'delimiter', ',');

                    dlmwrite( strcat( './KM-Runtime/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '.rtTrain' ), RT1, 'delimiter', ',');

                end
                
                if Test==1
                    tic;
                    DM2 = KMComp_TestToTrain(DS.Test, DS.Train, DistanceIndex, NewParameter1, NewParameter2);
                    RT2 = toc;

                    dlmwrite( strcat( './KM/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '_TestToTrain.distmatrix' ), DM2, 'delimiter', ',');

                    dlmwrite( strcat( './KM-Runtime/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '.rtTestToTrain' ), RT2, 'delimiter', ',');

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
                    % 1 - SINK          20 Parameters (20 x 1)
                    Params = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];  
                    Params2 = 0; 
            elseif DistanceIndex==2
                    % 2 - GAK           26 Parameters (26 x 1)
                    Params = [0.01,0.05,0.1,0.25,0.5,0.75,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
                    Params2 = 0; 
            elseif DistanceIndex==3
                    % 3 - KDTW          20 Parameters (20 x 1)
                    Params = [2^-15,2^-14,2^-13,2^-12,2^-11,2^-10,2^-9,2^-8,2^-7,2^-6,2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4];
                    Params2 = 0; 
            end


end

function [NewParameter1, NewParameter2] = ComputeParameters(X, DistanceIndex, Parameter1, Parameter2)

    [m, TSLength] = size(X);

    if DistanceIndex==2             
        % GAK tuning as suggested in author's website
        
        dists = [];
        for l=1:10
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
        NewParameter2 = Parameter2;

    else
        NewParameter1 = Parameter1;
        NewParameter2 = Parameter2;
    end

end



function RunKMNEWKernelsComp(DataSetStartIndex, DataSetEndIndex, DistanceIndex, Param1, Param2, Param1prime, Param2prime, Train, Test)

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
    dir_struct = dir('./UCR2018/');
    Datasets = {dir_struct(3:130).name};
                     
    % Sort Datasets
    
    [Datasets, ~] = sort(Datasets);
    
    %poolobj = gcp('nocreate');
    %delete(poolobj);
    
    %parpool(18);
    
    addpath(genpath('lockstepmeasures/.'));
    addpath(genpath('slidingmeasures/.'));
    addpath(genpath('kernelmeasuresnew/.'));
    
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
                    DM1 = KMNEWKernelsComp(DS.Train, DistanceIndex, NewParameter1, NewParameter2);
                    RT1 = toc;

                    dlmwrite( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '_Train.distmatrix' ), DM1, 'delimiter', ',');

                    dlmwrite( strcat( './KMNEWKERNELS-Runtime/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '.rtTrain' ), RT1, 'delimiter', ',');

                end
                
                if Test==1
                    tic;
                    DM2 = KMNEWKernelsComp_TestToTrain(DS.Test, DS.Train, DistanceIndex, NewParameter1, NewParameter2);
                    RT2 = toc;

                    dlmwrite( strcat( './KMNEWKERNELS/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '_TestToTrain.distmatrix' ), DM2, 'delimiter', ',');

                    dlmwrite( strcat( './KMNEWKERNELS-Runtime/',char(Datasets(i)),'/', char(Datasets(i)),'_',char(Methods(DistanceIndex)),'_', num2str(Params(w)),'_', num2str(Params2(wprime)), '.rtTestToTrain' ), RT2, 'delimiter', ',');

                end
                
                end
            end
            

        end
        
    end
    
    %poolobj = gcp('nocreate');
    %delete(poolobj);

end

function [Params,Params2] = DistanceToParameter(DistanceIndex)
    % 1 - LinearNCCc             0 Parameters (1 x 1)
    % 2 - GaussianNCCc           20 Parameters (20 x 1)
    % 3 - LogKernelNCCc          10 Parameters (5 x 1)
    % 4 - LogisticKernelNCCc     0 Parameters (1 x 1)
    % 5 - PolynomialNCCc         12 Parameters (4 x 3)
    % 6 - TanhNCCc               10 Parameters (10 x 1)
    % 7 - MultiQuadNCCc          10 Parameters (10 x 1)
    % 8 - RationalQuadNCCc       10 Parameters (10 x 1)
    % 9 - InverseMultiQuadNCCc   10 Parameters (10 x 1)
    % 10 - CauchyKernelNCCc      10 Parameters (10 x 1)
    %
    
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

function [NewParameter1, NewParameter2] = ComputeParameters(X, DistanceIndex, Parameter1, Parameter2)

    [m, TSLength] = size(X);

    if DistanceIndex==1232             
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



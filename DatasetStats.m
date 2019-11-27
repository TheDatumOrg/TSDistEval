
% first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
dir_struct = dir('./UCR2018-NEW');
dataset_names = {dir_struct(3:130).name};

Results = [];

for i = 1:length(dataset_names)

    disp(['Dataset being processed: ', char(dataset_names(i))]);

    DS = LoadOtherdatasetLocal(char(dataset_names(i)));

    ResultsTemp = [length(DS.ClassNames),DS.TrainInstancesCount,DS.TestInstancesCount,length(DS.Train(1,:))];
    Results = [Results;ResultsTemp];

                    
end



dlmwrite( './DatasetsStatistics', Results, 'delimiter', ' ');
               

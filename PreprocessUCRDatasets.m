% This script modifies the new UCR Time-Series Archive to make it backwards
% compatible with previous versions and enable older code and scripts to
% run without modifications.

% dir_new contains new, corrected, archive directory
dir_new = './UCR2018-NEW';

% first 2 values are '.' and '..' - UCR Archive 2018 version has 128 datasets
dir_struct = dir('../../UCRArchiveFix/code/UCRArchive2018/');
dataset_names = {dir_struct(3:130).name};

for i = 1:length(dataset_names)

    disp(['Dataset being processed: ', char(dataset_names(i))]);

    DS = LoadOtherdatasetLocal(char(dataset_names(i)));

    if length(DS.Train(1,:))>=1000
       NEWTRAIN = ResampleToSpecifiedLength(DS.Train,500);
       NEWTEST = ResampleToSpecifiedLength(DS.Test,500);
    else  
       NEWTRAIN = DS.Train;
       NEWTEST = DS.Test;
    end

    % z-normalize time series
    NEWTEST = zscore(NEWTEST,[],2);  
    NEWTRAIN = zscore(NEWTRAIN,[],2);


    if size(NEWTRAIN,1)>=1000
        [NewTrain,NewTrainLabels] = StratifiedSampling(NEWTRAIN,DS.ClassNames,DS.TrainClassLabels, 1000);      
    else
        NewTrain = NEWTRAIN;
        NewTrainLabels = DS.TrainClassLabels;
    end
    
    
    if size(NEWTEST,1)>=1000
        [NewTest,NewTestLabels] = StratifiedSampling(NEWTEST,DS.ClassNames,DS.TestClassLabels, 1000);     
    else
        NewTest = NEWTEST;
        NewTestLabels = DS.TestClassLabels;
    end

    % create new train and test datasets (i.e., merge labels with data)
    TRAIN = [NewTrainLabels,NewTrain];
    TEST = [NewTestLabels,NewTest];

    % save new datasets to new directory
    dir_path_new = [dir_new,'/',char(dataset_names(i)),'/',char(dataset_names(i))];

    dlmwrite([dir_path_new,'_TRAIN'],TRAIN, 'delimiter', ',');
    dlmwrite([dir_path_new,'_TEST'],TEST, 'delimiter', ',');
                    
end


function ResampledData = ResampleToSpecifiedLength(Data, NewLength)

    [rows, ~] = size(Data);
    ResampledData = zeros(rows, NewLength);

    for i = 1:rows
        singleTS = Data(i, :);
        singleTS = singleTS(~isnan(singleTS));

        ResampledData(i, :) = resample(singleTS, NewLength, length(singleTS));

    end

end



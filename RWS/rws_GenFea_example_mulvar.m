% This script generates low-rank approximation of latent kernel matrix using 
% random features approach based on dtw like distance for multi-variate 
% time-series datasets. Note: the default low-rank R = 512. 

clear,clc

addpath(genpath('utilities'));
file_dir = './datasets/';
filename = 'auslan';
disp(filename);
sigma = 0.79;
R = 512; % Generally, Large R, Better Accuracy.
DMin = 1;
DMax = 25;

timer_start = tic;
[trainData, testData] = rws_GenFea_mulvar(file_dir,filename,sigma,R,DMin,DMax);
trainy = trainData(:,1);
testy = testData(:,1);
% convert user labels to uniform format binary(-1,1) & multiclasses (1,2,..)
labels = unique(trainy);
numClasses = length(labels);
if numClasses > 2
    for i=1:numClasses
        ind = (trainy == labels(i));
        trainy(ind) = i;
    end
    for i=1:numClasses
        ind = (testy == labels(i));
        testy(ind) = i;
    end
else
    ind = (trainy == labels(1));
    trainy(ind) = -1;
    ind = (trainy == labels(2));
    trainy(ind) = 1;
    ind = (testy == labels(1));
    testy(ind) = -1;
    ind = (testy == labels(2));
    testy(ind) = 1;
end
trainData(:,1) = trainy;
testData(:,1) = testy;
telapsed_features_dtw_random = toc(timer_start)
csvwrite(strcat(file_dir,filename,'/',filename,'_rws_Train'), trainData);
csvwrite(strcat(file_dir,filename,'/',filename,'_rws_Test'), testData);
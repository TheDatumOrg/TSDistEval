% This script generates low-rank approximation of latent kernel matrix using 
% random features approach based on dtw like distance for UCR time-series 
% datasets. Expts A: investigate performance changes when varying R using
% the parameters learned from 10-folds cross validation with R = 128.
%
% Author: Lingfei Wu
% Date: 01/20/2019

clear,clc
nthreads = 12;
parpool('local', nthreads);
addpath(genpath('utilities'));
file_dir = './datasets/';

% List all datasets
filename_list = {'Gun_Point'};

DMin = 1;    
R_list = [4 8 16 32 64]; % Generally, Large R, Better Accuracy.
info = [];
for jj = 1:length(filename_list)
    filename = filename_list{jj};
    if strcmp(filename, 'Gun_Point')
        sigma = 4.46;
        DMax = 25;
        lambda_inverse = 10;
    end 
    
    Accu_best = zeros(2,length(R_list));
    telapsed_liblinear = zeros(1,length(R_list));
    real_total_dtw_time = zeros(1,length(R_list));
    real_user_dtw_time = zeros(1,length(R_list));
    for j = 1:length(R_list)
        R = R_list(j);
        [trainData,testData,telapsed_fea_gen]=rws_GenFea(file_dir,...
            filename,sigma,R,DMin,DMax);
        trainy = trainData(:,1);
        testy = testData(:,1);
        % convert user labels to uniform format binary(-1,1) & multiclasses (1,2,..)
        labels = unique(trainy);
        numClasses = length(labels);
        if numClasses > 2
            for i=numClasses:-1:1
                ind = (trainy == labels(i));
                trainy(ind) = i;
            end
            for i=numClasses:-1:1
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

        disp('------------------------------------------------------');
        disp('LIBLinear performs basic grid search by varying lambda');
        disp('------------------------------------------------------');
        trainFeaX = trainData(:,2:end);
        testFeaX = testData(:,2:end);

        % Linear Kernel
        timer_start = tic;
        s2 = num2str(lambda_inverse);
        s1 = '-s 2 -e 0.0001 -q -c ';
        s = [s1 s2];
        model_linear = train(trainy, sparse(trainFeaX), s);
        [train_predict_label, train_accuracy, train_dec_values] = ...
            predict(trainy, sparse(trainFeaX), model_linear);
        [test_predict_label, test_accuracy, test_dec_values] = ...
            predict(testy, sparse(testFeaX), model_linear);
        Accu_best(1,j) = train_accuracy(1);
        Accu_best(2,j) = test_accuracy(1);
        telapsed_liblinear(1,j) = toc(timer_start)
        real_total_dtw_time(1,j) = telapsed_fea_gen.real_total_dtw_time;
        real_user_dtw_time(1,j) = telapsed_fea_gen.user_dtw_time/nthreads;
    end
    info.Accu_best = Accu_best;
    info.real_total_dtw_time = real_total_dtw_time;
    info.real_user_dtw_time = real_user_dtw_time;
    info.telapsed_liblinear = telapsed_liblinear;
    info.R = R_list;
    info.DMin = DMin;
    info.DMax = DMax;
    info.sigma = sigma;
    info.lambda_inverse = lambda_inverse;
    disp(info);
    savefilename = [filename '_rws_VaryingR_CV_R128'];
    save(savefilename,'info')
end
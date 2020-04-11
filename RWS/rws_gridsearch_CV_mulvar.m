% This script generates low-rank approximation of latent kernel matrix using 
% random features approach based on dtw like distance for multi-variate 
% time-series datasets. User Liblinear to perform grid search with 
% K-fold cross-validation!
%
% Author: Lingfei Wu
% Date: 01/20/2019


clear,clc
parpool('local');
addpath(genpath('utilities'));
file_dir = './datasets/';

% List all datasets
filename_list = {'auslan'};

DMin = 1;
DMax_list = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100];
sigma_list = [1e-3 3e-3 1e-2 3e-2 0.10 0.14 0.19 0.28 0.39 0.56 ...
    0.79 1.12 1.58 2.23 3.16 4.46 6.30 8.91 10 31.62 1e2 3e2 1e3];

R = 32; % number of random time-series generated
CV = 10; % number of folders of cross validation
for jjj = 1:length(filename_list)
    filename = filename_list{jjj};
    disp(filename);
    
    info.aveAccu_best = 0;
    info.valAccuHist = [];
    info.DMaxHist = [];
    info.sigmaHist = [];
    info.lambda_invHist = [];
    for jj = 1:length(DMax_list)
    for j = 1:length(sigma_list)
        DMax = DMax_list(jj)
        sigma = sigma_list(j)
        
        % load, shuffle, and prepare the training data
        timer_start = tic;
        Data = load(strcat(file_dir,filename,'/',filename,'.mat'));
        trainX = Data.train_X;
        trainy = Data.train_Y;
        N = size(trainX,1);
        trainData = zeros(N, R+1);
        shuffle_index = randperm(N);
        trainX = trainX(shuffle_index); % shuffle the data
        trainy = trainy(shuffle_index);
        % generate random time series with variable length, where each
        % value in random series is sampled from Gaussian distribution
        % parameterized by sigma. 
        rng('default')
        sampleX = cell(R,1);
        d = size(trainX{1},1); % number of variates
        for i=1:R
            D = randi([DMin, DMax],1);
            sampleX{i} = randn(d, D)./sigma; % gaussian
        end
        trainFeaX_random = dtw_similarity_cell_mulvar(trainX, sampleX);
        trainFeaX_random = trainFeaX_random/sqrt(R); 
        trainData(:,2:end) = trainFeaX_random;
        % convert user labels to uniform format binary(-1,1) & 
        % multiclasses (1,2,..,k)
        labels = unique(trainy);
        numClasses = length(labels);
        if numClasses > 2
            for i=numClasses:-1:1
                ind = (trainy == labels(i));
                trainy(ind) = i;
            end
        else
            ind = (trainy == labels(1));
            trainy(ind) = -1;
            ind = (trainy == labels(2));
            trainy(ind) = 1;
        end
        trainData(:,1) = trainy;
        telapsed_fea_gen = toc(timer_start)

        disp('------------------------------------------------------');
        disp('LIBLinear performs basic grid search by varying lambda');
        disp('------------------------------------------------------');
        % Linear Kernel
        lambda_inverse = [1e-5 1e-4 1e-3 1e-2 1e-1 1 1e1 1e2 1e3 1e4 1e5];
        for i=1:length(lambda_inverse)
            valAccu = zeros(1, CV);
            for cv = 1:CV
                subgroup_start = (cv-1) * floor(N/CV);
                mod_remain = mod(N, CV);
                div_remain = floor(N/CV);
                if  mod_remain >= cv
                    subgroup_start = subgroup_start + cv;
                    subgroup_end = subgroup_start + div_remain;
                else
                    subgroup_start = subgroup_start + mod_remain + 1;
                    subgroup_end = subgroup_start + div_remain -1;
                end
                test_indRange = subgroup_start:subgroup_end;
                train_indRange = setdiff(1:N, test_indRange);
                trainFeaX = trainData(train_indRange,2:end);
                trainy = trainData(train_indRange,1);
                testFeaX = trainData(test_indRange,2:end);
                testy = trainData(test_indRange,1);
                
                s2 = num2str(lambda_inverse(i));
               s1 = '-s 2 -e 0.0001 -q -c '; % for regular liblinear
%                 s1 = '-s 2 -e 0.0001 -n 8 -q -c '; % for omp version
                s = [s1 s2];
                timer_start = tic;
                model_linear = train(trainy, sparse(trainFeaX), s);
                [test_predict_label, test_accuracy, test_dec_values] = ...
                    predict(testy, sparse(testFeaX), model_linear);
                telapsed_liblinear = toc(timer_start);
                valAccu(cv) = test_accuracy(1);
            end
            ave_valAccu = mean(valAccu);
            std_valAccu = std(valAccu);
            if(info.aveAccu_best+0.1 < ave_valAccu)
                info.DMaxHist = [info.DMaxHist;DMax];
                info.sigmaHist = [info.sigmaHist;sigma];
                info.lambda_invHist = [info.lambda_invHist;lambda_inverse(i)];
                info.valAccuHist = [info.valAccuHist;valAccu];
                info.valAccu = valAccu;
                info.aveAccu_best = ave_valAccu;
                info.stdAccu = std_valAccu;
                info.telapsed_fea_gen = telapsed_fea_gen;
                info.telapsed_liblinear = telapsed_liblinear;
                info.runtime = telapsed_fea_gen + telapsed_liblinear;
                info.sigma = sigma;
                info.R = R;
                info.DMin = DMin;
                info.DMax = DMax;
                info.lambda_inverse = lambda_inverse(i);
            end
        end
    end
    end
    disp(info);
    savefilename = [filename '_rws_R' num2str(R) '_' num2str(CV) 'fold_CV'];
    save(savefilename,'info')
end
delete(gcp);

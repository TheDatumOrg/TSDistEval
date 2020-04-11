# RandomWarpingSeries
RandomWarpingSeries (RWS) is a simple code for generating the vector representation of time-series for time-series classification, clustering, and regression.
This code is a simple implementation (mix of Matlab, Matlab MEX, and C) of the WME in (Wu et al, "Random Warping Series: A Random Features Method for Time-Series Embedding", AISTATS'18). We refer more information about RWS to the following paper link: http://proceedings.mlr.press/v84/wu18b/wu18b.pdf.


# Prerequisites

There are at least two required tool packages in order to run this code. You need to download DTW, LibLinear, or LibSVM and compile the corresponding MEX files for your operating systems (Mac, Linux, or Windows).

For DTW: https://www.mathworks.com/matlabcentral/fileexchange/43156-dynamic-time-warping-dtw <br/>
For LibSVM: https://github.com/cjlin1/libsvm or LibLinear: https://github.com/cjlin1/liblinear <br/>


For single-variate time-series datasets, you can download some datasets from the UCR time-series collections (http://www.cs.ucr.edu/~eamonn/time_series_data/) or from the UEA time-series collection (http://www.timeseriesclassification.com/). <br/> 
For multi-variate time-series datasets, you can download some datasets from UCI Machine Learning Repository (https://archive.ics.uci.edu/ml/index.php) or from your favorate applications. <br/>
It is generally advised to perform Z-formalization on data before feeding it to our time-series embedding codes. 


# How To Run The Codes
Note that, in order to achieve the best performance, the hyperparameters DMax, sigma, and even lambda_inverse (for classification using SVM) have to be searched (using cross validation or other techniques). This is a crucial step for RWS.  

To generate the RWS and use RWS for time-series claddification or clustering tasks, you need:

(1) If you use linux and Mac, you should be fine to skip compiling MEX for DTW, LibLinear, and LibSVM. Otherwise, you need to download them form the above links and compile them in their Matlab folders. Then you need copy these MEX files into the utilities folder.

(2) Open Matlab terminal console and run rws_gridsearch_CV.m on single-variate time-series for performing K-fold cross validation for searching good hyperparameters 
    The RWS embeddings that performs the best on the dev data will be saved.

(3) Open Matlab terminal console and run rws_gridsearch_CV_mulvar.m on multi-variate time-series for performing K-fold cross validation for searching good hyperparameters 
    The RWS embeddings that performs the best on the dev data will be saved. 

(4) Test the model by running the following code rws_VaryingR_CV_R128.m on single-variate time-series and rws_VaryingR_CV_R128_mulvar.m on multi-variate time-series using best parameters from CV
    The testing result on different data splits will be saved. 

(5) To generate RWS embedding only, please run this code rws_GenFea_example.m on single-variate time-series and rws_GenFea_example_mulvar.m on multi-variate time-series. <br/> 

Note that there are no default numbers for the hyperparameters DMax, sigma. You should searching for the best numbers before generating RWS time-series embeddings for your applications. In general, the larger the parameter R is, the better quality of embedding is. 


# How To Cite The Codes
Please cite our work if you like or are using our codes for your projects! Let me know if you have any questions: lwu at email.wm.edu.

Lingfei Wu, Ian En-Hsu Yen, Jinfeng Yi, Fangli Xu, Qi Lei, and Michael Witbrock, "Random Warping Series: A Random Features Method for Time-Series Embedding", AISTATS'18.

@inproceedings{wu2018random,  <br/>
  title={Random Warping Series: A Random Features Method for Time-Series Embedding},  <br/>
  author={Wu, Lingfei and Yen, Ian En-Hsu and Yi, Jinfeng and Xu, Fangli and Lei, Qi and Witbrock, Michael},  <br/>
  booktitle={International Conference on Artificial Intelligence and Statistics},  <br/>
  pages={793--802},  <br/>
  year={2018}  <br/>
}

------------------------------------------------------
Contributors: Lingfei Wu <br/>
Created date: January 20, 2019 <br/>
Last update: January 20, 2019 <br/>

EXECUTION INSTRUCTIONS
----------------------

These Matlab programs comprise an implementation of the 1-NN classifier for time series. All of the dis/similarity
measures employed in the paper experiments are among these programs.

In order to use our implementation, please follow these steps:



1) Load the dataset

The programs will expect each training/test dataset to be a matrix of N rows and M+1 columns, where N is the number of
examples and M is the length of the time series. The first column of each time example should be the time series class.

If you are using the UCR datasets (reference #10 in our paper), then you can load a dataset with the following lines of
Matlab code (example for the 'Coffee' dataset):

	training_dataset = load('Coffee_TRAIN');
	test_dataset = load('Coffee_TEST');



2) Set options for the 1-Nearest Neighbor

This implementation of the 1-Nearest Neighbor will take an optional parameter that contains options. These options
include an Epsilon value to compare floating-point numbers and any extra argument to be passed to the comparison measure
(such as the width of the Sakoe-Chiba band for our DTW implementation).

These options are a simple containers.Map object (standard Matlab key/value data structure). The +opts directory is a
package that makes it simple to work with them. Here's an example:

	options = opts.set('tie break', 'random');       % what 1-NN should do if here is more than one near. neighbor
	options = opts.set(options, 'measure arg', 5);   % NN will pass the value `5' to the measure



3) Run the 1-NN over the training/test datasets

The partitioned.m program will run the nn.m program. It takes three mandatory arguments and an optional set of options.
Here's an example to run with the DTW dissimilarity function:

	partitioned(training_dataset, test_dataset, @dtw, options)

The returned value will be the accuracy (% of number of correctly classified examples).

You can also run nn.m for a single time series (the nn.m file is well-documented). Here's a very simple example:

	sample = training_dataset(5, :);      % get the 5th time series
	nn(test_dataset, sample, @euclidean);

If you still have any doubts, please don't refrain from emailing me back.

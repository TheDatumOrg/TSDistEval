# SPIRAL

## Synopsis
We convert a set of time series with equal or unequal lengths to a matrix format. The matrix format can be used for data clustering or classification using existing machine learning models. 

## Testing Data
In ./data/ a test data "50words" comes from UCR Archive: http://www.cs.ucr.edu/~eamonn/time_series_data/

The data is in the format of a nxm matrix, consiting of n rows of samples. For each row, the first value is the label, and the remaining part is the time series data.

## Sample Run
* need to run "mex dtw_c.c" and "mex exactCDmex.c" in matlab
* sample run:
	* open Matlab
	* runme('50words')


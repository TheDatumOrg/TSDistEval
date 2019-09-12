#include "mex.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#define min(x, y) ((x)<(y)?(x):(y))
#define max(x, y) ((x)>(y)?(x):(y))
#define dist(x, y)((x-y)*(x-y))


#define INF 1e20       /*Pseudo Infitinte number for this code */



/*
 Calculate Dynamic Time Wrapping distance
 A,B: data and query, respectively
 r  : size of Sakoe-Chiba warpping band */
double dtw(double* A, double* B, int m, double *radius, int *path1, int *path2, int *pLen) {
    
    double *cost;
    double *cost_prev;
    double *cost_tmp;
    int i, j, k;
    double x, y, z;
    double final_dtw ;
    int r;
    
    int **trace;
    
    r = (int)radius[0];
    
    /* Traceback matrix width m x 2r+1 */
    trace = (int **)malloc(sizeof(int *)*m);
    for (i=0;i<m;i++)
        trace[i] = (int *)malloc(sizeof(int)*(2*r+1));
    
    /* Instead of using matrix of size O(m^2) or O(mr), we will reuse two array of size O(r). */
    cost = (double*)malloc(sizeof(double)*(2*r+1));
    for(k=0; k<2*r+1; k++)    cost[k]=INF;
    
    cost_prev = (double*)malloc(sizeof(double)*(2*r+1));
    for(k=0; k<2*r+1; k++)    cost_prev[k]=INF;
    
    for (i=0; i<m; i++) {
        k = max(0, r-i);
        
        for(j=max(0, i-r); j<=min(m-1, i+r); j++, k++) {
            /* Initialize all row and column */
            if ((i==0)&&(j==0)) {
                cost[k]=dist(A[0], B[0]);
                trace[0][r] = 0; /* 0: left 1: diag 2:up */
                continue;
            }
            
            /* Left */
            if ((j-1<0)||(k-1<0))     y = INF;
            else                      y = cost[k-1];
            /* Up */
            if ((i-1<0)||(k+1>2*r))   x = INF;
            else                      x = cost_prev[k+1];
            /* Diagonal */
            if ((i-1<0)||(j-1<0))     z = INF;
            else                      z = cost_prev[k];
            
            /* Classic DTW calculation */
            cost[k] = min( min( x, y) , z) + dist(A[i], B[j]);
            /* Let's store the path information */
            if      (x <= min(y, z))
                trace[i][k]= 2; /* up */
            else if (y <= min(x, z))
                trace[i][k]=0; /* left */
            else
                trace[i][k]=1; /* diag */
        }
        
        
        
        /* Move current array to previous array. */
        cost_tmp = cost;
        cost = cost_prev;
        cost_prev = cost_tmp;
    }
    k--;
    
    /* the DTW distance is in the last cell in the matrix of size O(m^2) or at the middle of our array. */
    final_dtw = cost_prev[k];
    free(cost);
    free(cost_prev);
    
    /* Print trace matrix */
    /* for (i=0;i<m;i++)
     * { for (j=0;j<2*r+1;j++)
     * printf("%3d ",trace[i][j]);
     * printf("\n");
     * } */
    /* Trace back */
    i = m - 1 ;
    j = r ;
    path1[0] = i; path2[0] = j + i - r ;
    /* printf("Sim [%3d %3d] Trace [%3d,%3d] = %3d\n",i,j+i-r,i,j,trace[i][j]); */
    for (k=1;  !(i == 0 && j == r) ; k++) {
        if      (trace[i][j] == 0) { j--;} /* left */
        else if (trace[i][j] == 1) { i--; } /* diag */
        else                       { i--; j++;} /* up */
        path1[k] = i ;
        path2[k] = j + i - r ;
        /*printf("Sim [%3d %3d] Trace [%3d,%3d] = %3d\n",i,j+i-r,i,j,trace[i][j]); */
    }
    *pLen = k--;
    
    for (i=0;i<m;i++)
        free(trace[i]);
    free(trace);
    
    return sqrt(final_dtw);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    double *q, *c, *r, *d;
    int ql, cl;
    int *path1, *path2;
    double *mxPath1, *mxPath2;
    int pLen, i;
    
    /* check number of inputs and outputs */
    if (nrhs != 3) {
        mexErrMsgTxt("This function requires 3 input arguments.");
    } else if (nlhs > 3) {
        mexErrMsgTxt("This function only returns 3 output value.");
    }
    
    /* retrieve input arguments */
    q = mxGetPr(prhs[0]);    /* pointer to real values of first  argument  */
    c = mxGetPr(prhs[1]);    /* pointer to real values of second argument */
    r = mxGetPr(prhs[2]);    /* pointer to real value  of third  argument   */
    
    /* check series lengths */
    ql = mxGetNumberOfElements(prhs[0]);
    cl = mxGetNumberOfElements(prhs[1]);
    if (abs(ql - cl) > r[0]) {
        mexErrMsgTxt("Actual distance falls outside radius constraint.");
    }
    
    /* allocate memory for the return value */
    plhs[0] = mxCreateDoubleMatrix(1, 1,    mxREAL);
    
    path1 = (int *)malloc(ql*(2*((int)r[0])+1)* sizeof(int));
    path2 = (int *)malloc(ql*(2*((int)r[0])+1)* sizeof(int));
    
    /* printf("Query Length:%d Path Length:%d\n", ql,ql*(2*((int)r[0])+1)); */
    d = mxGetPr(plhs[0]);    /* pointer to Matlab managed memory for result */
    
    d[0]=dtw(q, c, ql, r, path1, path2, &pLen);
    
    /* printf("Path length %d\n",pLen); */
    
    plhs[1] = mxCreateDoubleMatrix(1, pLen, mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1, pLen, mxREAL);
    
    mxPath1 = mxGetPr(plhs[1]);
    mxPath2 = mxGetPr(plhs[2]);
    
    for (i=0; i < pLen ; i++) {
        mxPath1[i] = path1[i] + 1 ; /* 1 based indexing */
        mxPath2[i] = path2[i] + 1 ; /* 1 based indexing */
    }
    
    free(path1);
    free(path2);
}

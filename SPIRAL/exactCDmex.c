/**
 * Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
 * Signal Analysis and Machine Perception Laboratory,
 * Department of Electrical, Computer, and Systems Engineering,
 * Rensselaer Polytechnic Institute, Troy, NY 12180, USA
 */

/**
 * This is the C/MEX code of dynamic time warping of two signals
 *
 * compile:
 *     mex dtw_c.c
 *
 * usage:
 *     d=dtw_c(s,t)  or  d=dtw_c(s,t,w)
 *     where s is signal 1, t is signal 2, w is window parameter
 */

#include "mex.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

double cubicRoot(double d)
{
	  if(d<0.0)
		        return -cubicRoot(-d);
	    else
			      return pow(d,1.0/3.0);
}

/* This function solves the following problem:
 min_{x>=0} x^3+ax+b */
double root_c(double a, double b)
{
    double x=0, y=0;
    double a3=4*pow(a,3), b2=27*pow(b,2);
    double delta = a3+b2;
	int k;
    if(delta<=0) /* 3 distinct real roots or 1 real multiple solution */
    {
	    double r3  = 2*sqrt(-a/3);
        double th3 = atan2(sqrt(-delta/108),-b/2)/3;
        double ymax=0, xopt=0;
        for(k=0;k<=4;k=k+2)
        {
            x = r3*cos(th3+((k*3.14159265)/3));
            y=pow(x,4)/4+a*pow(x,2)/2+b*x;
	 	    if(y<ymax)
	               {ymax=y; xopt=x;}
        }
        return xopt;
    }
    else /* 1 real root and two complex */
    {
         double z = sqrt(delta/27);
         x = cubicRoot(0.5*(-b+z))+cubicRoot(0.5*(-b-z));
         y = pow(x,4)/4+a*pow(x,2)/2+b*x;
         return x;
    }
}



double residue(double * nR, double normA, int n, int m, int * lenA)
{
	double r=0;
	int i,j;
	for (i=0;i<n;i++)
		for (j=0;j<lenA[i];j++)
			r+=nR[j*n+i]*nR[j*n+i];
	return r/normA/normA;
}

void iterations(double * nA, double *nR, int* nO, double * X, int n, int m, int k, int * lenA, int n_iter, double normA,int * d){
	int iter,i,j,t;
	double p,q;
	printf("# 0: residue=1\n");
	for (iter=0;iter<n_iter;++iter)
	{
	    for(i=0;i<k;i++)
		{/*column of X*/
            int in=i*n;
			for(t=0;t<n;t++)/*row of x_i=X[:,i]=X[i*n+...]*/
			{	double x=X[in+t];
				for (j=0;j<lenA[t];j++)/*R{t}=R{t}+x(t)*x(Omega{t})*/
		        	nR[j*n+t]+=x*X[in+nO[j*n+t]];
			}
			for(j=0;j<n;j++)
			{/*coordinate-wise update for X[j,i]*/
				/*     id=nO[j,:]
				 *     p=norm(x(id))^2-x(j)^2-R{j}(d(j));
                       q=-x(id)'*R{j}+R{j}(d(j))*x(j); */
	    	    p=q=0;
		    	for (t=0;t<lenA[j];t++)
				{
					int tn=t*n;
					p+=X[in+nO[tn+j]]*X[in+nO[tn+j]];
					q-=X[in+nO[tn+j]]*nR[tn+j];
				}
				p-=X[in+j]*X[in+j]+nR[j+n*d[j]];
		    	q+=nR[d[j]*n+j]*X[in+j];
		    	X[in+j]=root_c(p,q);
	    	}
		    for (t=0;t<n;t++)
			{
				double x=X[in+t];
		        for (j=0;j<lenA[t];j++)
			        nR[j*n+t]-=x*X[nO[j*n+t]+in];
			}
		}
		printf("# %d: residue=%f\n",iter+1,residue(nR,normA,n,m,lenA));
	}
}

/* the gateway function
X=exactCDmex(nA,nR,nO,X0,lenA,d,normA,options.maxiter);
*/

void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
	double *values;
	double normA;

	int n, k, m;
	int n_iter;

	double* nA = mxGetPr(prhs[0]);
	n=mxGetM(prhs[0]);
	m=mxGetN(prhs[0]);

	double * nR=mxGetPr(prhs[1]);
	values=mxGetPr(prhs[2]);
	int * nO=(int *)malloc(sizeof(int)*(n*m));
	int i;
	for (i=0;i<n*m;i++)
	    nO[i]=(int)(values[i]);

	double * X0= mxGetPr(prhs[3]);
	k=mxGetN(prhs[3]);
	values=mxGetPr(prhs[4]);
	int * lenA=(int *)malloc(sizeof(int)*n);

	for (i=0;i<n;++i)
	    lenA[i]=(int)(values[i]);
	values=mxGetPr(prhs[5]);
	int * d=(int *)malloc(sizeof(int)*n);
	for (i=0;i<n;++i)
	    d[i]=(int)(values[i]);

	values=mxGetPr(prhs[6]);
	normA=values[0];
	values=mxGetPr(prhs[7]);
	n_iter=values[0];

	iterations(nA,nR,nO,X0,n,m,k,lenA,n_iter,normA,d);

    /*  set the output pointer to the output matrix */
    plhs[0] = mxCreateDoubleMatrix( n, k, mxREAL);
	double *X = mxGetPr(plhs[0]);
	for(i=0; i<n*k; ++i)
		X[i]=X0[i];
	free(nO);
	free(lenA);
	free(d);
    return;

}

function xnew = SlidingZscore(x, n)

datamovmean = movmean(x,n);
datamovstd = movstd(x,n);
xnew = (x-datamovmean)./datamovstd;

end
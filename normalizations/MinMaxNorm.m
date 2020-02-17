function xnew = MinMaxNorm(x,alpha,beta)
     
    minvalue = min(x);
    maxvalue = max(x);
    
    xnew = alpha + ((x - minvalue)*(beta-alpha) ) / ( maxvalue - minvalue );
end
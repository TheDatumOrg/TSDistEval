function xnew = MeanNorm(x)
     
    minvalue = min(x);
    maxvalue = max(x);
    
    % x already has mean(x) subtracted
    xnew = x / ( maxvalue - minvalue );
end
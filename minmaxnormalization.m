function norm_data = minmaxnormalization(test)
     
    minvalue = min(test)-0.001;
    maxvalue = max(test)+0.001;
    
    norm_data = (test - minvalue) / ( maxvalue - minvalue );

end
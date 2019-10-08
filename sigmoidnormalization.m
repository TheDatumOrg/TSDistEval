function norm_data = sigmoidnormalization(test)
     
    norm_data = 1./(1-exp(-test));

end
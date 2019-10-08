function norm_data = sigmoidnormalization(test)
     test=test+5;
    norm_data = 1./(1-exp(-test));

end
function norm_data = mediannormalization(test)
     
    norm_data = test./median(test);

end
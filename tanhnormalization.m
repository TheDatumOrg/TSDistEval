function norm_data = tanhnormalization(test)
     
    norm_data = 0.5*(tanh(0.01*test)+1);

end
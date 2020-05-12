function sim = GaussianNCCc(x,y,gamma)
% Adapted for NCCc

cc = exp(gamma*NCCc(x,y));
sim = sum(cc);

end
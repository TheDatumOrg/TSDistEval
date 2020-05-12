function sim = LogisticKernelNCCc(x,y)
% Adapted for NCCc

cc = (1-NCCc(x,y));

sim = sum(1./(exp(cc)+2+exp(-cc)));

end
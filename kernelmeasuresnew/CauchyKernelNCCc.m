function sim = CauchyKernelNCCc(x,y,sigma)
% Adapted for NCCc

cc = 1./(1+((1-NCCc(x,y))./(sigma^2)));

sim = sum(cc);

end
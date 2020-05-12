function sim = LogKernelNCCc(x,y,d)
% Adapted for NCCc

cc = (1-NCCc(x,y)).^d +1;
sim = sum(-log(cc));

end
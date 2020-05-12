function sim = TanhNCCc(x,y,alpha)
% Adapted for NCCc

cc = tanh(alpha*NCCc(x,y));
sim = sum(cc);

end
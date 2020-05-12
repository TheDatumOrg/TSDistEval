function sim = InverseMultiQuadNCCc(x,y,c)
% Adapted for NCCc

cc = (1-NCCc(x,y))+c^2;

sim = sum(1./sqrt(cc));

end
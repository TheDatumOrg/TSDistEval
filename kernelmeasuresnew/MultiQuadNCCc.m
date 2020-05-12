function sim = MultiQuadNCCc(x,y,c)
% Adapted for NCCc

cc = (1-NCCc(x,y))+c^2;

sim = sum(sqrt(cc));

end
function sim = SINK(x,y,gamma)
% Shift INvariant Kernel

sim = SumExpNCCc(x,y,gamma)/sqrt(SumExpNCCc(x,x,gamma) * SumExpNCCc(y,y,gamma));

end

function sim = SumExpNCCc(x,y,gamma)

sim = sum(exp(gamma*NCCc(x,y)));

end
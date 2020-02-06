function sim = KDTWNorm(x,y,gamma)
% Shift INvariant Kernel

sim = kdtw(x,y,gamma)/sqrt(kdtw(x,x,gamma) * kdtw(y,y,gamma));

end

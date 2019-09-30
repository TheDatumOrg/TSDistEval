function sim = KDTWNorm(x,y,gamma)
% KDTW

sim = kdtw(x,y,gamma)/sqrt(kdtw(x,x,gamma) * kdtw(y,y,gamma));

end
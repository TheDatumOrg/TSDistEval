function d = minkowski(P, Q, p)
d = sum(abs(P - Q) .^ p) ^ (1/p);
end

function d = hellinger(P, Q)
d = 2 * sqrt(1 - (sum(sqrt(P .* Q))));
d = abs(d);
end
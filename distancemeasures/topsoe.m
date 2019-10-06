function d = topsoe(P, Q)
logPQ = log(P + Q);
d = sum(P .* (log(2*P) - logPQ) + Q .* (log(2 * Q) - logPQ));
d = abs(d);
end
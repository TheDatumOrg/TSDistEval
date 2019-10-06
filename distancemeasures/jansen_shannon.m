function d = jansen_shannon(P, Q)
logPQ = log(P + Q);
d = 0.5 * sum(P .* (log(2*P) - logPQ) + Q .* (log(2 * Q) - logPQ));
d = abs(d);
end
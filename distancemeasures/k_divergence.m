function d = k_divergence(P, Q)
d = sum(P .* log((2 * P) ./ (P + Q)));
d = abs(d);
end
function d = k_divergence(P, Q)
d = sum(P .* log((2 * P) ./ (P + Q)));

if ~isreal(d)
d = abs(d);
end

end
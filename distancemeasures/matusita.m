function d = matusita(P, Q)
d = sqrt(2 - 2 * sum(sqrt(P .* Q)));
d = abs(d);
end
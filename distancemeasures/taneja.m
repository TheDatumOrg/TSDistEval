function d = taneja(P, Q)
PQh = (P + Q) / 2;
d = sum(PQh .* log(PQh ./ sqrt(P .* Q)));
d = abs(d);
end
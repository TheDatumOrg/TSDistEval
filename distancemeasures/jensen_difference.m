function d = jensen_difference(P, Q)
PQh = (P + Q) / 2;
d = sum((P .* log(P) + Q .* log(Q)) / 2 - PQh .* log(PQh));
d = abs(d);
end
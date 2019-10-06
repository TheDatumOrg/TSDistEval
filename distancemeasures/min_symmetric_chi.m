function d = min_symmetric_chi(P, Q)
PQds = (P - Q).^ 2;
d = min(sum(PQds ./ P), sum(PQds ./ Q));
end
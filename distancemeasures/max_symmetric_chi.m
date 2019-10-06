function d = max_symmetric_chi(P, Q)
PQds = (P - Q).^ 2;
d = max(sum(PQds ./ P), sum(PQds ./ Q));
end
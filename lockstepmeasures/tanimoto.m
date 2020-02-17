function d = tanimoto(P, Q)
minPQ = min(P, Q);
sumPQ = sum(P) + sum(Q);
d = (sumPQ - 2 * minPQ) / (sumPQ - minPQ);
end
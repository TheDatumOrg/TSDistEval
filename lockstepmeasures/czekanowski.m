function d = czekanowski(P, Q)
d = sum(abs(P - Q)) / sum(P + Q);
end
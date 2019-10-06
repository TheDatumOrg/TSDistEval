function d = avg_l1_linf(P, Q)
d = (sum(abs(P - Q)) + max(abs(P - Q))) / 2;
end
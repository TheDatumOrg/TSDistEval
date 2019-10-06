function d = motyka(P, Q)
%distance
d = sum(max(P, Q)) / sum(P + Q);
end
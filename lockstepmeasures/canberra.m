function d = canberra(P, Q)
d = sum(abs(P - Q) ./ (P + Q));
end
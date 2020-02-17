function d = squared_chi(P, Q)
d = sum(((P - Q).^ 2) ./ (P + Q));
end
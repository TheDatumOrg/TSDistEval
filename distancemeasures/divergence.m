function d = divergence(P, Q)
d = 2 * sum(((P - Q).^ 2) ./ ((P + Q).^ 2));
end
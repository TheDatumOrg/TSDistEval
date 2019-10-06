function d = prob_symmetric_chi(P, Q)
d = 2 * sum(((P - Q).^ 2) ./ (P + Q));
end
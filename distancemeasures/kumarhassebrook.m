function d = kumarhassebrook(P, Q)
d = sum(P.*Q)/(sum(P.^2)+sum(Q.^2)-sum(P.*Q));
end
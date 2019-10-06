function d = emanon4(P, Q)
d = sum(((P - Q).^ 2) ./ max(P, Q));
end
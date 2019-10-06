function d = pearson(P, Q)
d = sum(((P - Q).^ 2) ./ Q);
end
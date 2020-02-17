function d = emanon3(P, Q)
d = sum(((P - Q).^ 2) ./ min(P, Q));
end
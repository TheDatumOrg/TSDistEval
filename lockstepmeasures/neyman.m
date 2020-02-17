function d = neyman(P, Q)
d = sum(((P - Q).^ 2) ./ P);
end
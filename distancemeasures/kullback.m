function d = kullback(P, Q)
d = sum(P .* log(P ./ Q));
d = abs(d);
end
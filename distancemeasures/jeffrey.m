function d = jeffrey(P, Q)
d = sum((P - Q) .* log(P ./ Q));
d = abs(d);
end
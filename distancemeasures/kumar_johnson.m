function d = kumar_johnson(P, Q)
d = sum((P.^2 - Q.^2).^2 ./ (2 * (P .* Q).^(3/2)));
d = abs(d);
end
function d = hellinger(P, Q)
d = 2 * sqrt(1 - (sum(sqrt(P .* Q))));

if ~isreal(d)
d = abs(d);
end

end
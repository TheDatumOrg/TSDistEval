function d = fidelity(P, Q)
d = sum(sqrt(P .* Q));

if ~isreal(d)
d = abs(d);
end

end
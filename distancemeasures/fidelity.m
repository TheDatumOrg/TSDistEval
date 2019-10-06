function d = fidelity(P, Q)
d = sum(sqrt(P .* Q));
d = abs(d);
end
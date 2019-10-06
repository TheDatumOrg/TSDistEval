function d = lorentzian(P, Q)
d = sum(log(1 + abs(P - Q)));
end
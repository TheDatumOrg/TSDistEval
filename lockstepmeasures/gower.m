function d = gower(P, Q)
d = 1/length(P) * sum(abs(P - Q));
end
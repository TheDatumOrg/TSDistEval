function d = clark(P, Q)
d = sqrt(sum(abs(P - Q).^2 ./ (P + Q)));
d = abs(d);
end
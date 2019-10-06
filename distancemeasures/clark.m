function d = clark(P, Q)
P=mat2gray(P);
Q=mat2gray(Q);
d = sqrt(sum(abs(P - Q).^2 ./ (P + Q)));
end
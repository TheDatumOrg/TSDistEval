function d = kulczynski(P, Q)
P=mat2gray(P);
Q=mat2gray(Q);
d = sum(abs(P - Q)) ./ sum(min(P, Q));
end
function d = abs_euclidean(P, Q)
d = sqrt(sum(abs(P - Q) .^ 2));
end

function d = additive_symm_chi(P, Q)
d = sum((P - Q).^2 .* (P + Q) ./ (P .* Q));
end
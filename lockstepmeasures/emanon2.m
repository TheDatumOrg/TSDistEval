function d = emanon2(P, Q)
d = sum(((P - Q).^2) ./ (min(P, Q).^2));
end
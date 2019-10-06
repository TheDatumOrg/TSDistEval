function d = dice(P, Q)
d = sum((P - Q).^2) / sum(P.^2 + Q.^2);
end
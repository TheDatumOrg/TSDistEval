function d = square_chord(P, Q)
d = sum((sqrt(P) - sqrt(Q)).^2);
d = abs(d);
end
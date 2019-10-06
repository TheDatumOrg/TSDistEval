function d = square_chord(P, Q)
d = sum((sqrt(P) - sqrt(Q)).^2);

if ~isreal(d)
d = abs(d);
end

end
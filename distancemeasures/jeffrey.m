function d = jeffrey(P, Q)
d = sum((P - Q) .* log(P ./ Q));

if ~isreal(d)
d = abs(d);
end

end
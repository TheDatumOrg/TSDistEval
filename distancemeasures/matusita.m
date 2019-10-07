function d = matusita(P, Q)
d = sqrt(2 - 2 * sum(sqrt(P .* Q)));

%if ~isreal(d)
%d = abs(d);
%end

end
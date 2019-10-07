function d = kullback(P, Q)
d = sum(P .* log(P ./ Q));

%if ~isreal(d)
%d = abs(d);
%end

end
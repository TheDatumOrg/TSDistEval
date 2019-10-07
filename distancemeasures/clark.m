function d = clark(P, Q)
d = sqrt(sum(abs(P - Q).^2 ./ (P + Q)));

%if ~isreal(d)
%d = abs(d);
%end

end
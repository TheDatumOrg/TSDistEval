function d = bhattacharyya(P, Q)
d = -log( sum(sqrt(P .* Q)) ) ;

if ~isreal(d)
d = abs(d);
end

end
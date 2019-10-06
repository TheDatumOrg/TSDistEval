function d = bhattacharyya(P, Q)
d = -log( sum(sqrt(P .* Q)) ) ;
d = abs(d);
end
function d = harmonicmean(P, Q)
d = 2*sum( P.*Q/(P+Q) );
end
function d = wavehedges(P, Q)
d = length(P) - sum(min(P, Q) ./ max(P, Q));
end
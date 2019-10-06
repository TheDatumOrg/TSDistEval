function d = vicis_wave_hedges(P, Q)
d = sum(abs(P - Q) ./ min(P, Q));
end
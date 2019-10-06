function d = cosine(P, Q)
d = 1-sum(P.*Q)/(sqrt(sum(P.^2))*sqrt(sum(Q.^2)));
end
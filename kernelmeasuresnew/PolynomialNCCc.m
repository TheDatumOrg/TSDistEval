function sim = PolynomialNCCc(x,y,alpha,d)
% Adapted for NCCc

cc = (alpha*NCCc(x,y)).^d;
sim = sum(cc);

end

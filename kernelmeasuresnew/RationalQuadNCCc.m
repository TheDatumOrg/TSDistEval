function sim = RationalQuadNCCc(x,y,c)
% Adapted for NCCc

cc = 1-((1-NCCc(x,y))./((1-NCCc(x,y))+c));

sim = sum(cc);

end
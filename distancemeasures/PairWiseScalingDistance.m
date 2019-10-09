function dist = PairWiseScalingDistance(x,y)
% we handle scaling outside of the function 
dist = norm(x - y) / norm(x);
end
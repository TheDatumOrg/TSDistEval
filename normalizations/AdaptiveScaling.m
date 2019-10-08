function [xnew,ynew] = AdaptiveScaling(x,y)
alpha = x * y' / (y * y');
ynew = alpha * y;
xnew = x;
end
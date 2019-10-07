function [x,y] = scale_d(x,y)
alpha = x * y' / (y * y');
y = alpha * y;
x = x;
end
function distance = MSM(X, Y, c)
% input:
%       X, Y - time series (each can be a row matrix, or a column matrix).
% output: 
%       MSM distance between X and Y. Note that this distance is computed
% using a hard wired value of c (cost of Split/Merge). Change this value if 
% you need to.


m = numel(X);
n = numel(Y);

Cost = zeros(m,n);

% Initialization
Cost(1,1) = abs( X(1) - Y(1) );
for i = 2 : m  % first column
    Cost(i,1) = Cost(i-1,1) + C( X(i), X(i-1), Y(1), c );
end
for j = 2 : n  % first row
    Cost(1,j) = Cost(1,j-1) + C( Y(j), X(1), Y(j-1), c );
end

% Main Loop
for i = 2:m
    for j = 2:n
        d1 = Cost(i-1,j-1) + abs( X(i) - Y(j) );
        d2 = Cost(i-1,j) + C( X(i), X(i-1), Y(j), c );
        d3 = Cost(i,j-1) + C( Y(j), X(i), Y(j-1), c );
        Cost(i,j) = min([d1,d2,d3]);
    end
end

% Output
distance = Cost(m,n);
end


function dist = C( new_point, x, y, c)

% c - cost of Split/Merge operation. Change this value to what is more
% appropriate for your data.
%c = 0.1;

if ( ( (x <= new_point) && (new_point <= y) ) || ...
     ( (y <= new_point) && (new_point <= x) ) )
    dist = c;
else
    dist = c + min ( abs(new_point-x) , abs(new_point-y) );
end

end
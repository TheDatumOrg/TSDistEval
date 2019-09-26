function [ distance, DP ] = TWED( A, timeSA, B, timeSB, lambda, nu )
% [distance, DP] = TWED( A, timeSA, B, timeSB, lambda, nu )
% Compute Time Warp Edit Distance (TWED) for given time series A and B
%
% A      := Time series A (e.g. [ 10 2 30 4])
% timeSA := Time stamp of time series A (e.g. 1:4)
% B      := Time series B
% timeSB := Time stamp of time series B
% lambda := Penalty for deletion operation
% nu     := Elasticity parameter - nu >=0 needed for distance measure
%
% Code by: P.-F. Marteau - http://people.irisa.fr/Pierre-Francois.Marteau/

    %Check if input arguments
    %if length(A) ~= length(timeSA)
    %    warning('The length of A is not equal length of timeSA')
    %    return
    %end

    %if length(B) ~= length(timeSB)
    %    warning('The length of B is not equal length of timeSB')
    %    return
    %end

    %if nu<0
    %    warning('nu is negative')
    %    return
    %end
    % Add padding
    A  = [ 0 A ];
    timeSA = [ 0 timeSA ];
    B  = [ 0 B ];
    timeSB = [ 0 timeSB ];

    % Dynamical programming
    DP = zeros(length(A),length(B));

    % Initialize DP Matrix and set first row and column to infinity
    DP(1,:) = inf;
    DP(:,1) = inf;
    DP(1,1) = 0;

    n = length(timeSA);
    m = length(timeSB);
    % Compute minimal cost
    for i = 2:n
        for j = 2:m
            cost = Dlp(A(i), B(j));

            % Calculate and save cost of various operations
            C = ones(3,1) * inf;

            % Deletion in A
            C(1) = DP(i-1,j) +  Dlp(A(i-1),A(i)) + nu * (timeSA(i) - timeSA(i-1)) + lambda;
            % Deletion in B
            C(2) = DP(i,j-1) + Dlp(B(j-1),B(j)) + nu * (timeSB(j) - timeSB(j-1)) + lambda;
            % Keep data points in both time series
            C(3) = DP(i-1,j-1) + Dlp(A(i),B(j)) + Dlp(A(i-1),B(j-1)) + ...
                   nu * ( abs( timeSA(i) - timeSB(j) ) + abs( timeSA(i-1) - timeSB(j-1) ) );

            % Choose the operation with the minimal cost and update DP Matrix
            DP(i,j) = min(C);
        end
    end

    distance = DP(n,m);

    % Function to calculate euclidean distance
    function [cost] = Dlp( A, B)
        cost = sqrt( sum( (A - B).^2 ,2));
    end

end

function [ path ] = backtracking( DP )
% [ path ] = BACKTRACKING ( DP )
% Compute the most cost efficient path
% DP := DP matrix of the TWED function

    x = size(DP);
    i = x(1);
    j = x(2);

    % The indices of the paths are save in opposite direction
    path = ones(i + j, 2 ) * Inf;

    steps = 1;
    while( i ~= 1 || j ~= 1 )
        path(steps,:) = [i; j];

        C = ones(3,1) * inf;

        % Keep data points in both time series
        C(1) = DP(i-1,j-1);
        % Deletion in A
        C(2) = DP(i-1,j);
        % Deletion in B
        C(3) = DP(i,j-1);

        % Find the index for the lowest cost
        [~,idx] = min(C);

        switch idx
            case 1
                % Keep data points in both time series
                i = i-1;
                j = j-1;
            case 2
                % Deletion in A
                i = i-1;
                j = j;
            case 3
                % Deletion in B
                i = i;
                j = j-1;
        end
        steps = steps +1;
    end
    path(steps,:) = [i j];

    % Path was calculated in reversed direction.
    path = path(1:steps,:);
    path = path(end:-1:1,:);

end
function [neighbor, best_dist, class, right] = nn(stack, needle, dist_fun, options)
% RUNS.NN Run 1-Nearest Neighbor over dataset
%
%   N = NN(D, S, F) will find the nearest neighbor of "S" in the dataset
%   "D" according to distance or similarity function "F". The index of the
%   nearest neighbor in "D" will be stored in "N".
%
%   [N, P] = NN(D, S, F) will return the index of the nearest neighbor in
%   "N" and its proximity to "S" in "P".
%
%   [N, P, C] = NN(D, S, F) will return the index of the nearest neighbor
%   in "N", its proximity to "S" in "P", and its class in "C"
%
%   [N, P, C, A] = NN(D, S, F) will return the index of the nearest
%   neighbor in "N", its proximity to "S" in "P", its class in "C", and
%   either "1" or "0" depending on whether the found nearest neighbor is of
%   same class as the test time series.
%
%   NN(N, S, F, X) takes an options set "X" compatible with the following
%   options: similarity, tie break, epsilon.

% Read options
if ~exist('options', 'var')
    options = opts.empty;
end

% Is this a similarity function?
is_sim = opts.get(options, 'similarity', 0);
if is_sim
    sim_fix = -1;
else
    sim_fix = 1;
end

% Does the measure take some argument
if opts.has(options, 'measure arg')
    measure_has_arg = 1;
    measure_arg = opts.get(options, 'measure arg');
else
    measure_has_arg = 0;
end

% Do we need tie break? May be "random", "first", or "none".
tie_break = opts.get(options, 'tie break', 'first');

% What epsilon shall we use?
epsilon = opts.get(options, 'epsilon', 1e-10);

% List of best indices and their distances...
best_idx = [];
best_dist = sim_fix * inf;

num_instances = size(stack, 1);

% Run 1-NN
for i = 1 : num_instances
    % First index of each time series contains class, so series are
    % compared by their [2,end] intervals
    if measure_has_arg
        dist = sim_fix * dist_fun(stack(i, 2:end), needle(2:end), measure_arg);
    else
        dist = sim_fix * dist_fun(stack(i, 2:end), needle(2:end));
    end
    
    % Is this the closest or just as close as the closest we previously found?
    if abs(dist - best_dist) < epsilon
        best_idx = [best_idx; i];
    elseif dist < best_dist
        best_idx = [i];
        best_dist = dist;
    end
end

% If we got more than one nearest neighbor, we need to decide on one of
% them, depending on the tie break strategy. Unless we are set to not
% perform any tie break at all. In that case we just return what we got
if isequal(tie_break, 'none')
    neighbor = best_idx;
else
    if length(best_idx) == 1 || isequal(tie_break, 'first')
        neighbor = best_idx(1);
    elseif isequal(tie_break, 'random')
        neighbor = randsample(best_idx, 1);
    end
    
    class = stack(neighbor, 1);
    right = abs(class - needle(1)) < epsilon;
end
end

function [acc, indices, classes] = partitioned(train, test, dist_fun, options)
% RUNS.PARTITIONED Run NN over the partitioned data
if ~exist('options', 'var')
    options = opts.empty;
end

num_test_instances = size(test, 1);
classes = zeros(1, num_test_instances);
indices = zeros(1, num_test_instances);

hits = 0;

for i = 1 : num_test_instances
    indices(i) = nn(train, test(i,:), dist_fun, options);
    classes(i) = train(indices(i), 1);
    if runs.same_class(classes(i), test(i, 1), options)
        hits = hits + 1;
    end
end

acc = hits / num_test_instances;
end
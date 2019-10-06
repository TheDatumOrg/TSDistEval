function out = has(option, key)
% HAS Check for existence of key in OPTS field
%   HAS(X, K) will return 1 if X is an OPTS field and it contains a vlaue
%   for the key K; 0 otherwise

out = opts.isa(option) && option.isKey(key);
end


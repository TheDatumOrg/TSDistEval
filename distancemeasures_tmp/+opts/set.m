function out = set(arg1, arg2, arg3)
% OPTS.SET Set an option to an options set
%
%   X = OPTS.SET(K, V) will create a new options set and add the value "V"
%   to the option "K" (for key). K is expected to be a string and V can be
%   an object of any type.
%
%   X = OPTS.SET(X, K, V) will add option "K" with value "V" to previously
%   existin options set "X".
if nargin == 3
    out = arg1;
    out(arg2) = arg3;
else
    out = containers.Map;
    out(arg1) = arg2;
end
end
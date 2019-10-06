function value = get(set, name, default)
if ~exist('default', 'var')
    default = 0;
end

if isequal(class(set), 'containers.Map') && set.isKey(name)
    value = set(name);
else
    value = default;
end
end
function vector = fix_vector_version(vector, type)
% type 1 is column vector, type 2 is row vector
if type == 1 && size(vector, 2) ~= 1 % Want column, but it's row vector
    vector = vector';
elseif type == 2 && size(vector,1) ~= 1
    vector = vector';
end
end
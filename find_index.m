function index = find_index(list, value, tolerance)
global Field;
index = -1; % Just to see that if we get -1 we didn't find the index

for i = 1 : length(list)
    if (list(i) + tolerance  >= value) && (list(i) - tolerance <= value)
        index = i;
        break;
    end
end

end
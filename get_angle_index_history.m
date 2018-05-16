function angle_index_history = get_angle_index_history(angles_list, ...
    tolerance_angle, steps, angle_step)

angle_index_history = zeros(1, steps);
for i = 1 : steps
    angle_index_history(i) = find_index(angles_list, i*angle_step, ...
        tolerance_angle);
end

end
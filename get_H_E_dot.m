function H_E_dot = get_H_E_dot(iteration, time_step)
global Field Angles_Position_Indeces;
H_E_dot = zeros(3,1); % We have to change this, but this is just for testing for now.
if iteration > 1
    Field_1 = get_Field(Angles_Position_Indeces(iteration - 1));
    Field_2 = get_Field(Angles_Position_Indeces(iteration));
    H_E_dot = (Field_2 - Field_1)/time_step;
end

end
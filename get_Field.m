function field_at_i = get_Field(index)
global Field;
field_at_i = Field(index, 2:4)'; % Will return the magnetic field at index
                                 % index as a column vector.
end
function [Test_Field angle_step_size] = generate_test_field(n, type)
% Type 1: constantly increasing
% Type 2: Sinusodial
Test_Field = zeros(n, 4);
Test_Field(:,1) = linspace(0,360, n);
t = linspace(0, 2*pi, n);
for i = 2 : 4
    if type == 1
        Test_Field(:,i) = linspace(0,10,n);
    elseif type == 2
        Test_Field(:,i) = 10.*cos(t);
    end
end

angle_step_size = abs(Test_Field(2,1) - Test_Field(1,1));

end 
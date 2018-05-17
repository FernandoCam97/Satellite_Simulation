Data = zeros(1,length(Angles_Position_Indeces));
for i = 1 : length(Angles_Position_Indeces)
    Data(i) = Field(Angles_Position_Indeces(i),1);
end
plot(1:length(Angles_Position_Indeces),Data,1:length(Angles_Position_Indeces),theta)
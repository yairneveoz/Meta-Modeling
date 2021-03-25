function aLck_probability_array = aLckProbabilityArray(...
    decay_disk,array_size_x_pixels,array_size_y_pixels,...
    CD45_x_pixels,CD45_y_pixels)


CD45_locations_array = ...
    zeros(array_size_x_pixels,array_size_y_pixels);

linind_CD45 = sub2ind(size(CD45_locations_array),...
    CD45_x_pixels,CD45_y_pixels);

CD45_locations_array(linind_CD45) = 1;

probability_sum = ...
    conv2(CD45_locations_array, decay_disk, 'same');

aLck_probability_array = probability_sum;

%%
% figure(4)
% h2 = surf(probability_sum);
% h2.EdgeColor = 'none';
% colormap(cyan_blue_colormap)

%%

end



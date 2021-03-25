% model3_run_sample
%% TCR_locations %%%%%%%%%%%%%%%%%%%%%%
[TCR_x_pixels,TCR_y_pixels] = radialDistributionArray(...
    TCR_cluster_density,TCR_r1,TCR_r2,pixel_size,...
    array_size_x_microns,array_size_y_microns);

%% TCR_locations array %%%%%%%%%%%%%%%%
TCR_locations_array = ...
    zeros(array_size_x_pixels,array_size_y_pixels);

linind_TCR = sub2ind(size(TCR_locations_array),...
    TCR_x_pixels,TCR_y_pixels);

TCR_locations_array(linind_TCR) = 1;

%% CD45 locations %%%%%%%%%%%%%%%%%%%%%
[CD45_x_pixels,CD45_y_pixels] = radialDistributionArray(...
                CD45_cluster_density,CD45_r1,CD45_r2,pixel_size,...
                array_size_x_microns,array_size_y_microns);
            

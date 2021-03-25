function normalized_counts = sumOverRings(array)

% max radius of rings:
R_max = round(min(size(array))/2);

% creat pixels rings:
pixel_rings = rings2array(R_max);
linind_rings = linindrings(pixel_rings);

% zeros array to center the rings:
center_point_array = zeros(size(array));
center_point_array(ceil(size(array,2)/2),...
                   ceil(size(array,1)/2)) = 1;

% initialize 'normalized_sum_values_on_rings':
normalized_sum_values_on_rings = zeros(R_max,1);

for r_pixels = 1:R_max
    
    % ring size array:
    ring_array = zeros(2*r_pixels-1);
    % a ring of pixels:
    ring_array(linind_rings{r_pixels}) = 1;
    
    % ring 'area' is calculated as the number of pixels
    % consisting the ring:
    ring_area = sum(sum(ring_array));
    
    % putting the ring on the full array:
    ring_on_full_array = conv2(center_point_array, ring_array, 'same');
    
    % linear index of the ring point on the full array:
    linind_ring_on_full_array = find(ring_on_full_array);
    
    % sum values on ring:
    values_on_ring = array(linind_ring_on_full_array);

    % sum devided by ring area:
    normalized_sum_values_on_rings(r_pixels) = ...
        sum(values_on_ring)/ring_area;
    
end

normalized_counts = normalized_sum_values_on_rings;

end





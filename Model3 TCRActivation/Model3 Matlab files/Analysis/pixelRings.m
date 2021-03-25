function pixel_rings = pixelRings(R_max)
%   
pixel_rings = cell(1,R_max);

for r_pixels = 1:R_max
    if r_pixels == 1
        r_pixels_ring(r_pixels) = 1;
    elseif r_pixels == 2
        r_pixels_ring = ones(2*r_pixels - 1);
        r_pixels_ring(2,2) = 0;
    else
        r_array = zeros(2*r_pixels - 1);
        r_array(r_pixels,r_pixels) = 1;
        
        r2_pixels_disk = ceil(fspecial('disk',r_pixels));
        r1_pixels_disk = ceil(fspecial('disk',r_pixels-1));
        
        r2_array_disk = conv(r_array,r2_pixels_disk, 'same');
        r1_array_disk = conv(r_array,r1_pixels_disk, 'same');
        
        r_pixels_ring = r2_array_disk - r1_array_disk;
    end
    pixel_rings{r_pixels} = r_pixels_ring;
end

% pixel_rings

end
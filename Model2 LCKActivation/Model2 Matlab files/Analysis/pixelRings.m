function pixel_rings = pixelRings(R_max)
%   
%
for r_pixels = 1:R_max
    if r_pixels == 1
        r_pixels_ring(r_pixels) = 1;
    elseif r_pixels == 2
        r_pixels_ring = ones(2*r_pixels - 1);
        r_pixels_ring(2,2) = 0;
    else
        r_array = zeros(2*r_pixels - 1);
%         r_array(r_pixels,r_pixels) = 1;
        r_pixels_disk = ceil(fspecial('disk',r_pixels));
    end
end






end
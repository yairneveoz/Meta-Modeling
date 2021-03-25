function CD45_density_array_pixels = ...
    CD45density(mu_CD45_nm, sigma_CD45_nm, pixels_array)


mu_CD45_pixels = round(mu_CD45_nm/10); % pixels
sigma_CD45_pixels = round(sigma_CD45_nm/10); % pixels
r = 1:1:round(size(pixels_array,1)/2);

pd_CD45 = makedist('Normal','mu',mu_CD45_pixels,...
                         'sigma',sigma_CD45_pixels);
% radial_pdf_CD45 = pdf(pd_CD45, r);
% 2D CD45 radial distribution
pixels_x = [1:1:size(pixels_array,1)] - ...
    round(size(pixels_array,1)/2);
pixels_y = [1:1:size(pixels_array,1)] - ...
    round(size(pixels_array,1)/2);

[mesh_pixels_x, mesh_pixels_y] = ... 
meshgrid(pixels_x, pixels_y);

[~, r_pixels] = cart2pol(mesh_pixels_x, mesh_pixels_y);

% CD45_density_array_pixels = zeros(size(pixels_array));

CD45_density_array_pixels = pdf(pd_CD45, r_pixels);

figure(11)
surf(CD45_density_array_pixels); shading interp

end
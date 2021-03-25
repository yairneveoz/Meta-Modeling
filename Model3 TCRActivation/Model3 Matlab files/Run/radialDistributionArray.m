function [x_pixels,y_pixels] = radialDistributionArray(...
    D,r1,r2,a,array_size_x_microns,array_size_y_microns)
% number of point as a function of density and area:
N = round(D*pi*(r2^2 - r1^2));

% P_r,
%% microns to pixels:
array_size_x_pixels = array_size_x_microns*1000/a;
array_size_y_pixels = array_size_y_microns*1000/a;
r1_pixels = r1*1000/a;
r2_pixels = r2*1000/a;

%% create a pixels array:
pixels_array = zeros(array_size_x_pixels,array_size_y_pixels);
x = 1:1:array_size_x_pixels;
y = 1:1:array_size_y_pixels;

%% create meshgrid:
[X,Y] = meshgrid(x,y);
center_x_pixels = ceil(array_size_x_pixels/2);
center_y_pixels = ceil(array_size_y_pixels/2);

%% select full ring:
all_ring_locations = pixels_array;
all_ring_locations(...
    (X - center_x_pixels).^2 + (Y - center_y_pixels).^2 > r1_pixels^2 &...
    (X - center_x_pixels).^2 + (Y - center_y_pixels).^2 < r2_pixels^2) = 1;

%% selct N random points from the selected ring:
linind_ones = find(all_ring_locations);
% s = RandStream('mlfg6331_64'); 
N_rand_sample = randsample(linind_ones,N,false);
pixels_array(N_rand_sample) = 1;

% return:
radial_distribution_array = pixels_array;

[x_pixels,y_pixels] = find(radial_distribution_array);
end

function pixels = setPixels(parameters)

pixels.size = parameters.sizes.pixel_size;

pixels_array = zeros(parameters.sizes.array_size_x_microns*...
    1000/pixels.size,...
    parameters.sizes.array_size_y_microns*...
    1000/pixels.size);
pixels.array = pixels_array;

pixels.Nx = size(pixels_array,1);
pixels.Ny = size(pixels_array,2);

% pixels_x, pixels_y with centers at 0:
pixels.x = 1:1:pixels.Nx;
pixels.y = 1:1:pixels.Ny;
% pixels.x = -pixels.Nx/2+1:1:pixels.Nx/2;
% pixels.y = -pixels.Ny/2+1:1:pixels.Ny/2;

pixels.xmin = min(pixels.x);
pixels.xmax = max(pixels.x);
pixels.ymin = min(pixels.y);
pixels.ymax = max(pixels.y);

% meshgrid for x,y pixels:
[mesh_pixels_x, mesh_pixels_y] = ...
    meshgrid(pixels.x, pixels.y);

pixels.mesh_x = mesh_pixels_x;
pixels.mesh_y = mesh_pixels_y;

% xmin = -size(pixels_array,1)/2;
% xmax = size(pixels_array,1)/2;
% ymin = -size(pixels_array,2)/2;
% ymax = size(pixels_array,2)/2;   






end
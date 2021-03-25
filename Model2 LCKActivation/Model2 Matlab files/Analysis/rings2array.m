function rings = rings2array2(max_R)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
input      : max_R
output     : rings
called by  : defaultANALYSESparameters
calling    : none
description: creating rings with radius = ring_radius 
and saving them in an array of rings.
ring_points_array = cell(1,max_R);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ring_points_array = cell(1,max_R+1);

for ring_radius = 0:max_R
    [X,Y] = meshgrid(-ring_radius:ring_radius);
    ring_points = floor(sqrt(X.^2 + Y.^2)) == ring_radius;
    [ring_x,ring_y] = find(ring_points);
    ring_points_array{ring_radius+1} = [ring_x,ring_y];
end
rings = ring_points_array;
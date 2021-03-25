function LCK_activation_locations_array = ...
    LCKactivationArray(CD45_density_array_pixels, max_Pon)

Pon_array = max_Pon*CD45_density_array_pixels/...
    max(max(CD45_density_array_pixels));
random_array = rand(size(CD45_density_array_pixels));
LCK_activation_locations_array = random_array < Pon_array;

figure(12)
h3 = pcolor(1*LCK_activation_locations_array);
set(h3, 'EdgeColor', 'none')
axis equal
axis tight
title('LCK activation locations')
xlabel('x(pixels)')
ylabel('y(pixels)')     


end
% plot_data

figure(1)
% h = pcolor(mesh_pixels_x, mesh_pixels_y, pixels_array);
% set(h, 'EdgeColor', 'none')
% colormap(gray)
% xlabel('x(pixels)')
% ylabel('y(pixels)')
% axis equal
% 

subplot(2,2,1)
scatter(LCK_x0, LCK_y0, '.')
axis equal
axis tight
title('LCK initial distribution')
xlabel('x(pixels)')
ylabel('y(pixels)')
% axis([xmin xmax ymin ymax])
box on
           
           









function decay_disk = decayDisk(decay_length,a,R_max)


lambda = 1/decay_length;
decay_length_nm = decay_length;
decay_length_pixels = decay_length_nm/a;
% R_max = round(4*decay_length_pixels);
r = 1:R_max;

% radial distribution 
z = lambda*exp(-r/decay_length_pixels);
% theta = 0:2*pi/R_max:2*pi-pi/R_max;
x = -R_max:1:R_max;
y = -R_max:1:R_max;
[X,Y] = meshgrid(x,y);
R = sqrt(X.^2 + Y.^2);
Z = lambda*exp(-R/decay_length_pixels);
Z = Z/sum(sum(Z));
decay_disk = Z;

% figure(3)
% subplot(1,2,1)
% plot(r,z)
% 
% subplot(1,2,2)
% h1 = surf(X, Y, Z);
% h1.EdgeColor = 'none';
% colormap(cyan_blue_colormap)

%%
% locations_array = zeros(400);
% 
% locations_array(200,100) = 1;
% locations_array(150,100) = 1;
% 
% distribution_sum = conv2(locations_array, Z, 'same');
% figure(4)
% h2 = surf(distribution_sum);
% h2.EdgeColor = 'none';
% colormap(cyan_blue_colormap)


end




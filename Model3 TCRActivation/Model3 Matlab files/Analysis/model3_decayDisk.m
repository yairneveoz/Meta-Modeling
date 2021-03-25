function decay_disk = model3_decayDisk(decay_length_nm,pixel_size,R_max)

% decay_length_nm = 1/lambda;
decay_length_pixels = decay_length_nm/pixel_size;
% R_max = round(4*decay_length_pixels);
r = 1:R_max;

% radial distribution 
x = -R_max:1:R_max;
y = -R_max:1:R_max;
[X,Y] = meshgrid(x,y);
R = sqrt(X.^2 + Y.^2);
Z = exp(-R/decay_length_pixels);

decay_disk = Z;

% figure(3)
% z = lambda*exp(-r/decay_length_pixels);
% subplot(1,2,1)
% plot(r,z)
% 
% subplot(1,2,2)
% h1 = surf(X, Y, Z);
% h1.EdgeColor = 'none';
% colormap(cyan_blue_colormap)

end
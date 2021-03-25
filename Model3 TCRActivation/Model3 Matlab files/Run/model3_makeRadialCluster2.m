function [x,y] = makeRadialCluster2(D,r1,r2)

N = round(D*pi*(r2^2 - r1^2));
rand_x = r2*rand(10*N,1);
rand_y = r2*rand(10*N,1);

[~,rand_r] = cart2pol(rand_x,rand_y);
rand_r(rand_r > r2) = [];
rand_r(rand_r < r1) = [];
rand_theta = 2*pi*rand(size(rand_r));
[x0,y0] = pol2cart(rand_theta,rand_r);

all_inds = 1:size(rand_r);
selected_inds = randsample(all_inds,N,false);

x = x0(selected_inds);
y = y0(selected_inds);

end
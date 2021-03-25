function norm_rings_counts = radialDensity2(r_max,ring_width,x,y)

rs = ring_width:ring_width:r_max; % rings radii
rcs = rs(2:end) - ring_width/2;
xy = [x,y];
rings_counts = zeros(1,size(rs,2)-1);
for r_ind = 1:length(rs)-1
    
    r1 = rs(r_ind);
    r2 = rs(r_ind+1);
    
    circle_counts1 = size(xy(sqrt(x.^2 + y.^2) < r1),1);
    circle_counts2 = size(xy(sqrt(x.^2 + y.^2) < r2),1);
    ring_counts = circle_counts2 - circle_counts1;
    rings_counts(r_ind) = ring_counts;
end
norm_rings_counts = rings_counts./rcs;

end
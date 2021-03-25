function linind_rings = linindrings2(rings)

max_R = length(rings);
linind_rings0 = cell(1,max_R); 
for ring_radius = 1:max_R % 1:51
    one_ring_points = rings{ring_radius}; 
    frame_size = 2*(ring_radius-1) + 1;
    linind_one_ring_points = sub2ind([frame_size,frame_size],...
        one_ring_points(:,1),one_ring_points(:,2));
    linind_rings0{ring_radius} = linind_one_ring_points;
end
linind_rings = linind_rings0;
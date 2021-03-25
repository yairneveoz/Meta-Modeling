% model2_run

% initial locations of LCK molecules. (it is assumed to be 
% random uniform but can be changed to other initial distributions). 
initial_LCK_x = ceil((rand(1,N_LCK))*pixels.Nx); % 
initial_LCK_y = ceil((rand(1,N_LCK))*pixels.Ny);

initial_LCK_x = ones(1,N_LCK)*ceil(pixels.Nx/2); % 
initial_LCK_y = ones(1,N_LCK)*ceil(pixels.Ny/2);
%% LCK paths:
% returns the pixels_x, pixels_y loactions alomg the paths.
% we assume periodic boundary conditions. THe length of the
% path is set by N_steps and the mean step size is set by LCK_diff:
% all paths start at (0,0).
iteration_time = parameters.time.iteration_time;
N_iterations = parameters.time.N_iteration;

[LCK_x_locations_pixels, LCK_y_locations_pixels] = ...
    LCK_paths_pixels(initial_LCK_x, initial_LCK_y, ...
    LCK_Diff, N_iterations, N_LCK, iteration_time, pixels.array);

%% LCK activation:
% checking when a path is passing through an activation location.
% presenting LCK activation locations in linear index (linind):
linind_LCK_activation_locations = ...
    find(LCK_activation_locations_array);

% representing LCK paths locations in linear index (linind):
linind_LCK_paths_locations = sub2ind(size(pixels.array),...
    LCK_x_locations_pixels, LCK_y_locations_pixels);

% figure(17)
% plot(LCK_x_locations_pixels(:), LCK_y_locations_pixels(:),'.');
%%  LCK on activation locations:
% logical array of location of paths that coincide with
% LCK activation locations.
turn_on_array = ismember(linind_LCK_paths_locations,...
    linind_LCK_activation_locations);

%% off events
% a (0,1) array of size = [N_steps,N_LCK] that sets when an
% active LCK will be turned off.
% off_array = ones(N_steps, N_LCK);

rand_off_array = rand(N_iterations, N_LCK);
turn_off_array = rand_off_array > LCK_Poff;

%% creating on/off states:
LCK_all_location_array_sum = zeros(size(pixels.array));
LCK_active_location_array_sum = zeros(size(pixels.array));
LCK_inactive_location_array_sum = zeros(size(pixels.array));
states_array = false(N_iterations, N_LCK);
% all initial states are off: 

% if an 'off' state meets a turn_on it becomes 'on' state.
% if an 'on' state meets a turn_off it becomes 'off' state.


for s = 1:N_iterations-1
    % s is the index of the row of the arrays (turn_on_array,
    % turn_off_row):
    % checks what molecules at iteration s will be activated:
    turn_on_row  = turn_on_array(s,:);
    % checks what molecules at iteration s will be inactivated:
    turn_off_row = turn_off_array(s,:);
    
    % define a 'states_raw' that is the state of the Lck 
    % and is a result of 'turn_on_row' and 'turn_off_row': 
    states_row   = states_array(s,:);
    
    % 'on_row' values are 'True' if 'turn_on_row' are 'True' or
    % 'state_row' are 'True'. ('states_row' is the result of
    % the previous iteration):
    on_row  = turn_on_row | states_row;
    
    % The new 'state_row' values are 'True' if both the 
    % 'turn_off_row' values (0 = turn_off) and 'on_row' values
    % are 'True':
    states_row = turn_off_row & on_row;

    % assign the 'states_row' to the 'states_array' at 
    % iteration s:
    states_array(s,:) = states_row;
    % assign the 'states_array(s,:)' to the next row (s+1)
    % of 'states_array' to be equal to 'states_array(s,:)':
    states_array(s+1,:) = states_array(s,:);

    %%% location array of state_array(s,:)
    linind_LCK_active_location_s = ...
        linind_LCK_paths_locations(s,states_array(s,:));
    
    
    LCK_active_location_array_s = zeros(size(pixels.array));
    LCK_active_location_array_s(linind_LCK_active_location_s) = 1;

    LCK_active_location_array_sum = ...
        LCK_active_location_array_sum +...
        LCK_active_location_array_s;

end

%% results statistics:

pixel_rings = rings2array(R_max);
linind_rings = linindrings(pixel_rings);

point_array = zeros(pixels.Nx, pixels.Ny);
point_array(ceil(pixels.Nx/2), ceil(pixels.Ny/2)) = 1;


normalized_sum_values_on_rings = zeros(R_max,1);

for r_pixels = 1:R_max
    ring_array = zeros(2*r_pixels-1);
    ring_array(linind_rings{r_pixels}) = 1;
    ring_area = sum(sum(ring_array));
    ring_on_full_array = conv2(point_array, ring_array, 'same');
    linind_ring_on_full_array = find(ring_on_full_array);
    % sum values on ring
    values_on_ring = LCK_active_location_array_sum(linind_ring_on_full_array);
%     sum_values_on_rings(r_pixels) = sum(values_on_ring);
    normalized_sum_values_on_rings(r_pixels) = sum(values_on_ring)/ring_area;
end
results_3D(LCK_Diff_ind, LCK_Poff_ind, :) = ...
    normalized_sum_values_on_rings;        

% main
% LCK_activation_simulation
%% define parameters:
parameters.time.total_time = 10; % sec
parameters.time.iteration_time = 0.01; % sec

parameters.sizes.pixel_size = 10; % nm
parameters.sizes.array_size_x_microns = 4; % um
parameters.sizes.array_size_y_microns = 4; % um

parameters.molecules.CD45.cluster_density = 1000; % #/um^2
% LCK
parameters.molecules.LCK.total_density = 300; % #/um^2
parameters.molecules.LCK.color = [0.0, 0.0, 0.6]; % rgb
parameters.molecules.LCK.Diff = 0.3; % #/um^2

% aLCK
parameters.molecules.LCK.color = [1.0, 0.5, 1.0]; % rgb
parameters.molecules.LCK.Poff = 1e-3; % 
parameters.molecules.LCK.global_density = 100; % #/um^2
parameters.molecules.LCK.max_Pon = 0.7;
%% red_gray_colomap:
Nc = 64;
red_gray_reds = [0:1/(Nc-1):1];
red_gray_greens = zeros(size(red_gray_reds)); %[0:1/(Nc-1):1]*0.5 + 0.5;
red_gray_blues = zeros(size(red_gray_reds)); %[0:1/(Nc-1):1]*0.5 + 0.5;
red_gray_map = [red_gray_reds',red_gray_greens',red_gray_blues'];
%% pixels array:
pixels_array = zeros(parameters.sizes.array_size_x_microns*100,...
                     parameters.sizes.array_size_y_microns*100);

N_pixels_x = size(pixels_array,1);
N_pixels_y = size(pixels_array,2);

% pixels_x, pixels_y with centers at 0:
pixels_x = -N_pixels_x/2+1:1:N_pixels_x/2;
pixels_y = -N_pixels_y/2+1:1:N_pixels_y/2;

% meshgrid for x,y pixels:
[mesh_pixels_x, mesh_pixels_y] = ...
    meshgrid(pixels_x, pixels_y);

xmin = -size(pixels_array,1)/2;
xmax = size(pixels_array,1)/2;
ymin = -size(pixels_array,2)/2;
ymax = size(pixels_array,2)/2;           
%% CD45 density distribution:
% returns radial density distribution of CD45 that is set 
% by mu_CD45 and sigma_CD45.
mu_CD45_nm = 600; % nm
sigma_CD45_nm = 100; % nm

CD45_density_array_pixels = ...
    CD45density(mu_CD45_nm, sigma_CD45_nm, pixels_array);
%% LCK_activation_locations_array:
LCK_activation_locations_array = ...
    LCKactivationArray(CD45_density_array_pixels,...
    parameters.molecules.LCK.max_Pon);
%% initial LCK locations:
LCK_Diff = 0.01; % 0.3
LCK_Poff = 0.01;
N_steps = 200;
N_Diff = 20;
N_Poff = 19;
LCK_Diff_values = [0.01, 0.02, 0.03 0.05, 0.1, 0.2, 0.3, 0.5,  1]; % um^2/sec
LCK_Poff_values = 10.^(-5:0.5:0); 
iteration_time = 0.01; 
for LCK_Diff_ind = 1:size(LCK_Diff_values,2)
    LCK_Diff = LCK_Diff_values(LCK_Diff_ind);
    for LCK_Poff_ind = 1:size(LCK_Poff_values,2)
        LCK_Poff = LCK_Poff_values(LCK_Poff_ind);
        
        % area of array in microns:
        area_microns = parameters.sizes.array_size_x_microns*...
                       parameters.sizes.array_size_y_microns;
        % total number of LCK molecules:
        N_LCK = parameters.molecules.LCK.global_density*area_microns;

        % initial locations of LCK molecules. (it is assumed to be 
        % random uniform but can be changed to other initial distributions). 
        initial_LCK_x = ceil((rand(1,N_LCK))*size(pixels_array,1)); % 
        initial_LCK_y = ceil((rand(1,N_LCK))*size(pixels_array,2));

        %% LCK paths:
        % returns the pixels_x, pixels_y loactions alomg the paths.
        % we assume periodic boundary conditions. THe length of the
        % path is set by N_steps and the mean step size is set by LCK_diff:
        % all paths start at (0,0).

        [LCK_x_locations_pixels, LCK_y_locations_pixels] = ...
            LCK_paths_pixels(initial_LCK_x, initial_LCK_y, ...
            LCK_Diff, N_steps, N_LCK, iteration_time, pixels_array);


        % figure(5)
        % plot(LCK_x_locations_pixels(:,1:end),...
        %      LCK_y_locations_pixels(:,1:end),'.-')
        %% LCK activation:
        % checking when a path is passing through an activation location.
        % presenting LCK activation locations in linear index (linind):
        linind_LCK_activation_locations = ...
            find(LCK_activation_locations_array);

        % representing LCK paths locations in linear index (linind):
        linind_LCK_paths_locations = sub2ind(size(pixels_array),...
            LCK_x_locations_pixels, LCK_y_locations_pixels);

        % figure(17)
        % plot(LCK_x_locations_pixels(:), LCK_y_locations_pixels(:),'.');
        %%  LCK on activation locations:
        % logical array of location of paths that coincide with
        % LCK activation locations.
        turn_on_array = ismember(linind_LCK_paths_locations,...
            linind_LCK_activation_locations);

        figure(14)
        % A2 = zeros(size(pixels_array));
        % A2(linind_LCK_paths_locations) = 1;
        % imagesc(A2)
        spy(turn_on_array)
        % imagesc(linind_LCK_paths_locations)
        title('turn on array')
        %% off events
        % a (0,1) array of size = [N_steps,N_LCK] that sets when an
        % active LCK will be turned off.
        % off_array = ones(N_steps, N_LCK);

        rand_off_array = rand(N_steps, N_LCK);
        turn_off_array = rand_off_array > LCK_Poff;

        %% creating on/off states:
        LCK_active_location_array_sum = zeros(size(pixels_array));
        states_array = false(N_steps, N_LCK);
        % all initial states are off: 

        % if an 'off' state meets a turn_on it becomes 'on' state.
        % if an 'on' state meets a turn_off it becomes 'off' state.


        for s = 1:N_steps-1
            turn_on_row  = turn_on_array(s,:);
            turn_off_row = turn_off_array(s,:);
            states_row   = states_array(s,:);
            on_row  = turn_on_row | states_row; 
            states_row = turn_off_row & on_row;

            states_array(s,:) = states_row;
            states_array(s+1,:) = states_array(s,:);

            %%% location array of state_array(s,:)
            linind_LCK_active_location_s = ...
                linind_LCK_paths_locations(s,states_array(s,:));

            LCK_active_location_array_s = zeros(size(pixels_array));
            LCK_active_location_array_s(linind_LCK_active_location_s) = 1;

            LCK_active_location_array_sum = LCK_active_location_array_sum +...
                LCK_active_location_array_s;

        end

        figure(15)
        imagesc(LCK_active_location_array_sum)

        %% results statistics:
        R_max = ceil(size(pixels_array,1)/2);
        pixel_rings = rings2array2(R_max);
        linind_rings = linindrings2(pixel_rings);

        point_array = zeros(N_pixels_x, N_pixels_y);
        point_array(ceil(N_pixels_x/2), ceil(N_pixels_y/2)) = 1;

        sum_values_on_rings = zeros(R_max,1);
        normalized_sum_values_on_rings = zeros(R_max,1);

        for r_pixels = 1:R_max
            ring_array = zeros(2*r_pixels-1);
            ring_array(linind_rings{r_pixels}) = 1;
            ring_area = sum(sum(ring_array));
            ring_on_full_array = conv2(point_array, ring_array, 'same');
            linind_ring_on_full_array = find(ring_on_full_array);
            % sum values on ring
            values_on_ring = LCK_active_location_array_sum(linind_ring_on_full_array);
            sum_values_on_rings(r_pixels) = sum(values_on_ring);
            normalized_sum_values_on_rings(r_pixels) = sum(values_on_ring)/ring_area;
        end

        % figure(17)
        % % spy(ring_on_full_array)
        % hold on
        % A3 = zeros(size(pixels_array));
        % A3(linind_ring_on_full_array) = 1;
        % spy(A3,'r')
        % hold off

        %%
        figure(18)

        r = 1:R_max;
        CD45_pdf = exp(-0.5*((r-60)/10).^2);
        plot(r, CD45_pdf, 'r', 'LineWidth', 2)
        hold on
        plot(r, normalized_sum_values_on_rings, 'b')
        legend('CD45 distribution','Normalized counts')
        hold off
        xlabel('radius(pixels)')
        ylabel('counts normalized to rings areas')


        % plot_data
    end
end
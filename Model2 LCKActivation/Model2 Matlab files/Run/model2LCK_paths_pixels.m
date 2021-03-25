function [LCK_x_locations_pixels, LCK_y_locations_pixels] = ...
    LCK_paths_pixels(initial_LCK_x, initial_LCK_y,...
    LCK_Diff, N_steps, N_LCK, iteration_time, pixels_array)
% read from parameters:

% creates initial LCK locations and a N_steps 2D random walk
% path for every LCK with periodic boundary conditions.

% mean LCK step size per iteration:
LCK_mean_step_size_pixels = ...
    1000/10*sqrt(4*iteration_time*LCK_Diff); % #nm

% Uniform random angles:
LCK_steps_angle = 2*pi*rand(N_steps, N_LCK);

% HalfNormal random radii in nm:
LCK_steps_r = LCK_mean_step_size_pixels*...
    abs(randn(N_steps, N_LCK));

% making path origin at (0,0):
LCK_steps_r(1,:) = 0;

% x,y steps in nm:
[LCK_steps_x_pixels, LCK_steps_y_pixels] = ...
    pol2cart(LCK_steps_angle,LCK_steps_r);

% x,y paths in nm:
LCK_paths_x_pixels0 = ceil(cumsum(LCK_steps_x_pixels,1));
LCK_paths_y_pixels0 = ceil(cumsum(LCK_steps_y_pixels,1));

% add initial locations to paths starting at (0,0):
LCK_paths_x_pixels = LCK_paths_x_pixels0 + ...
    repmat(initial_LCK_x, N_steps,1);
LCK_paths_y_pixels = LCK_paths_y_pixels0 + ...
    repmat(initial_LCK_y, N_steps,1);

% applying periodic boundary conditions:
size_x_pixels = size(pixels_array,1);
size_y_pixels = size(pixels_array,2);

LCK_paths_x_pixels = ...
    mod(LCK_paths_x_pixels, size_x_pixels);
LCK_paths_y_pixels = ...
    mod(LCK_paths_y_pixels, size_y_pixels);

LCK_x_locations_pixels = LCK_paths_x_pixels+1;
LCK_y_locations_pixels = LCK_paths_y_pixels+1;
    
end
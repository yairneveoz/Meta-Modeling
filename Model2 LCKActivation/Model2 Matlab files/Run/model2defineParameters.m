function parameters = defineParameters()

% time and space parameters:
parameters.time.total_time = 10; % sec
parameters.time.iteration_time = 0.01; % sec
parameters.time.N_iteration = round(...
    parameters.time.total_time/...
    parameters.time.iteration_time);  

parameters.sizes.pixel_size = 10; % nm
parameters.sizes.array_size_x_microns = 2; %4; % um
parameters.sizes.array_size_y_microns = 2; %4; % um
parameters.sizes.area_microns = ...
    parameters.sizes.array_size_x_microns*...
    parameters.sizes.array_size_y_microns;

% LCK parameters:
parameters.molecules.LCK.global_density = 100; % #/um^2
parameters.molecules.LCK.color = [0.0, 0.0, 0.6, 1.0]; % rgb
parameters.molecules.LCK.Diff = 0.3; % #/um^2
% total number of LCK molecules:
parameters.molecules.LCK.N = ...
    parameters.molecules.LCK.global_density*...
    parameters.sizes.area_microns;

% aLCK parameters:
parameters.molecules.aLCK.color = [1.0, 0.5, 1.0, 1.0]; % rgb
parameters.molecules.LCK.Poff = 1e-2; % 
parameters.molecules.LCK.max_Pon = 0.7;

end
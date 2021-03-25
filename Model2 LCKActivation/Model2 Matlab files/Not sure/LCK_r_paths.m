function [LCK_r, LCK_active_r] = ...
    LCK_r_paths(LCK_Diff, LCK_Poff, N_steps, N_LCK,...
    iteration_time)
    
    % mean LCK step size per iteration:
    LCK_mean_step_size_nm = ...
        1000*sqrt(4*iteration_time*LCK_Diff); % #nm
    
    % Uniform random angles:
    LCK_steps_angle = 2*pi*rand(N_steps, N_LCK);

    % HalfNormal random radii in nm:
    LCK_steps_r = LCK_mean_step_size_nm*...
        abs(randn(N_steps, N_LCK));
    
    % making path origin at (0,0):
    LCK_steps_r(1,:) = 0;
    
    % x,y steps in nm:
    [LCK_steps_x, LCK_steps_y] = ...
        pol2cart(LCK_steps_angle,LCK_steps_r);
    
    % x,y paths in nm:
    LCK_paths_x = cumsum(LCK_steps_x,1);
    LCK_paths_y = cumsum(LCK_steps_y,1);
    
    % representing paths in radii and angles:
    [~,LCK_paths_r] = ...
        cart2pol(LCK_paths_x,LCK_paths_y);
    
    % initialize array of active (on) LCK.
    LCK_on = ones(N_steps, N_LCK);

    % ramdom array for random selection of inactive LCK.
    rand_array = rand(N_steps, N_LCK);

    % if rand_array < Poff active LCK will become inactive.
    Poff_array = rand_array < LCK_Poff;
    LCK_on(Poff_array) = 0;

    % if an LCK becomes inactive it will stay inactive.
    cumprod_LCK_on = cumprod(LCK_on,1);

    %
    LCK_r = LCK_paths_r;
    LCK_active_r = cumprod_LCK_on.*LCK_paths_r;

end




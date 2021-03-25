% two_dimensional_random_walk2
clc
clear

total_time = 10; % sec
iteration_time = 0.01; % sec
N_iterations = 1000;

N_LCK = 500; %200; %1000;
N_steps = 1000;

%%% LCK on/off states
% Initialy all LCK's are active at the origin.
% The probability of an active LCK to become inactive
% in one iteration is Poff.

binranges = 0:100:8000; % nm

for LCK_Diff = 0.3:0.3

    for LCK_Poff = 0.01:0.01 
        % LCK paths, LCK active paths:
        [LCK_r, LCK_active_r] = ...
            LCK_paths(LCK_Diff, LCK_Poff, N_steps, N_LCK,...
            iteration_time);
        
        % LCK counts, LCK active counts:
        [LCK_r_counts, LCK_active_r_counts] = ...
            LCK_counts(LCK_r, LCK_active_r, binranges);
        
        plot_results
    end
end

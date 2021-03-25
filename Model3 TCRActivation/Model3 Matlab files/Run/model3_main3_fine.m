% model3_main2
clear
clc

%%% setup for model3:
% molecules colors:
TCR_color  = [0.0, 0.6, 0.0];
CD45_color = [1.0, 0.0, 0.0];
aLCK_color = [1.0, 0.0, 1.0];
pTCR_color = [1.0, 0.5, 0.0];

%%% array size
array_size_x_microns = 2; %4;
array_size_y_microns = 2; %4;
pixel_size = 10; % nm
array_size_x_pixels = array_size_x_microns*1000/pixel_size;
array_size_y_pixels = array_size_y_microns*1000/pixel_size;

TCR_cluster_density = 1000; %N/um^2
TCR_r1 = 0; % microns
TCR_r2 = 0.25; % microns

CD45_cluster_density = 1000; %N/um^2
CD45_r1 = 0.45; % 0.45 microns
CD45_r2 = CD45_r1 + 0.3; % microns

%% % run_sample:
model3_run_sample;

%% % plot run_sample results:
model3_plot_run_sample;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% batch parameters:
batch_depletion_range_nm = 0:10:200; %0:20:300; % 0:50:750; % nm 100
batch_aLCK_decay_length_nm = 0:10:200; %0:10:150; % 25:25:300; % nm 200

%%%
N_samples = 10;
N_bins = 100; %200;

%%% run over batch parameters: 
model3_run;

%%% save run's results:
% model3_save_run_results;
%% save results:
save('TCR_hist_model3_fine2.mat', 'dep_decay_TCR_normalized_counts');
dlmwrite('TCR_hist_model3_fine2.m', dep_decay_TCR_normalized_counts);
dlmwrite('TCR_hist_model3_fine2', dep_decay_TCR_normalized_counts);
dlmwrite('TCR_hist_model3_fine2.npy', dep_decay_TCR_normalized_counts);
% 
save('pTCR_hist_model3_fine2.mat', 'dep_decay_pTCR_normalized_counts');
dlmwrite('pTCR_hist_model3_fine2.m', dep_decay_pTCR_normalized_counts);
dlmwrite('pTCR_hist_model3_fine2', dep_decay_pTCR_normalized_counts);
dlmwrite('pTCR_hist_model3_fine2.npy', dep_decay_pTCR_normalized_counts);
% 
dep_decay_rTCR_normalized_counts = ...
    dep_decay_pTCR_normalized_counts./...
    dep_decay_TCR_normalized_counts;

save('rTCR_hist_model3_fine2.mat', 'dep_decay_rTCR_normalized_counts');
dlmwrite('rTCR_hist_model3_fine2.m', dep_decay_rTCR_normalized_counts);
dlmwrite('rTCR_hist_model3_fine2', dep_decay_rTCR_normalized_counts);
dlmwrite('rTCR_hist_model3_fine2.npy', dep_decay_rTCR_normalized_counts);
%%

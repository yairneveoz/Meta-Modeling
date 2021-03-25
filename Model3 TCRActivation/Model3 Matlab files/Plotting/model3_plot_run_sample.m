% model3_plot_run_sample

%% plot TCR and CD45 location %%%%%%%%%
figure(4)
subplot(2,2,1)
% spy(TCR_locations_array)
plot(TCR_x_pixels,TCR_y_pixels,'.','Color',TCR_color)
hold on
plot(CD45_x_pixels,CD45_y_pixels,'.','Color',CD45_color)
hold off
axis equal
axis([0 400 0 400])

%% decay_disk: %%%%%%%%%%%%%%%%%%%%%%%%
% lambda = 0.01; % 1/nm
R_max = 200;
decay_length_nm = 100;
decay_disk = model3_decayDisk(decay_length_nm,pixel_size,R_max);
norm_decay_disk = decay_disk/sum(sum(decay_disk));

%% plot decay_disk %%%%%%%%%%%%%%%%%%%%
Nc = 64;
cyan_blue_colormap = cyanBlueColormap(Nc);

figure(4)
subplot(2,2,2)
h1 = surf(norm_decay_disk);
h1.EdgeColor = 'none';
colormap(cyan_blue_colormap)
axis tight

%% aLck_probability_array %%%%%%%%%%%%%
aLck_probability_array = aLckProbabilityArray(...
    norm_decay_disk,array_size_x_pixels,array_size_y_pixels,...
    CD45_x_pixels,CD45_y_pixels);

%%% plot surf(aLck_probability_array)
subplot(2,2,3)
h2 = surf(aLck_probability_array);
h2.EdgeColor = 'none';
colormap(cyan_blue_colormap)

%% TCR phosphorylation pattern %%%%%%%%
pTCR_probability_array = TCR_locations_array.*aLck_probability_array;

subplot(2,2,4)
h3 = pcolor(pTCR_probability_array);
h3.EdgeColor = 'none';

axis equal
axis tight
axis([150 250 150 250])
% freezeColors
colormap(parula)

%% sum over angles:
TCR_normalized_counts = sumOverRings(TCR_locations_array);
pTCR_normalized_counts = sumOverRings(pTCR_probability_array);

figure(5)
bar(1:length(TCR_normalized_counts),TCR_normalized_counts)
hold on
bar(1:length(TCR_normalized_counts),100*pTCR_normalized_counts)
hold off

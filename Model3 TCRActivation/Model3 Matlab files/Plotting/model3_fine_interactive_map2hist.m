% model3_interactive_map2hist
clc
%% read data:
% read max_diff array:
rTCR_max_diff_heatmap = dlmread('rTCR_max_diff_array_fine.m');

% read TCR historgrams 3D array:
TCR_hist_model3_3D = load('TCR_hist_model3_fine');
TCR_hist_model3 = ...
    TCR_hist_model3_3D.dep_decay_TCR_normalized_counts;

% read TCR historgrams 3D array:
pTCR_hist_model3_3D = load('pTCR_hist_model3_fine');
pTCR_hist_model3 = ...
    pTCR_hist_model3_3D.dep_decay_pTCR_normalized_counts;

%% plot heatmap:
% model3_heatmap = [];
dep_indices = 1:size(rTCR_max_diff_heatmap,1);
dec_indices = 1:size(rTCR_max_diff_heatmap,2);

dep_values = 0:20:300; % nm
dec_values = 0:10:150; % nm

figure(7)
subplot(1,2,1)
pcolor(rTCR_max_diff_heatmap)
v = [0.0005:0.0005:0.003];

hold on
[h2,c2] = contour(rTCR_max_diff_heatmap,v,'ShowText','on');
c2.LineColor = [1, 1, 1];
hold off
colorbar
title('Max difference of pTCR histogram')
xlabel('Decay length (nm)')
ylabel('Depletion (nm)')
xticks(2:2:length(dec_values))
yticks(2:2:length(dep_values))
xticklabels(10*[1:2:length(dec_values)])
yticklabels(20*[1:2:length(dep_values)])
% xt
axis equal
axis tight

[gdec,gdep] = ginput(1);
gdep = floor(gdep);
gdec = floor(gdec);
disp(gdep)
disp(gdec)

ind_dep1 = gdep;
ind_dec1 = gdec;

subplot(1,2,1)
boxx = [0 1 1 0 0];
boxy = [0 0 1 1 0];
hold on
plot([ind_dec1+boxx],[ind_dep1+boxy],'r-','LineWidth',1)
hold off

%% get heatmap coordinates

%% plot histograms accordind to heatmap coordinates:
rr = 1:size(TCR_hist_model3,3);

subplot(1,2,2)
bar(rr, squeeze(TCR_hist_model3(ind_dep1,ind_dec1,:)),...
    'FaceColor',[0, 0.6, 0])
hold on
bar(rr, 20*squeeze(pTCR_hist_model3(ind_dep1,ind_dec1,:)),...
    'FaceColor',[1.0, 0.6, 0])
hold off
xlim([0 40])
ylim([0 0.2])
xticks([0:10:40]);
xticklabels(10*[0:10:40])
xlabel('r(nm)')
legend('TCR','pTCR')
axis square











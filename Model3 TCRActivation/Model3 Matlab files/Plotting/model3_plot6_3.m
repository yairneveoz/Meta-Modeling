% model3_plot6_2
clc
% molecules colors:
TCR_color  = [0.0, 0.6, 0.0];
CD45_color = [1.0, 0.0, 0.0];
aLCK_color = [1.0, 0.0, 1.0];
pTCR_color = [1.0, 0.7, 0.0];

s_pixels = 200;
limits1 = [0 s_pixels 0 s_pixels];
array_size_x_pixels = 200;
array_size_y_pixels = 200;
array_size_x_microns = array_size_x_pixels/100;
array_size_y_microns = array_size_y_pixels/100;

%% generate x,y data: %%%%%%%%%%%%%%%%%
%% TCR_locations %%%%%%%%%%%%%%%%%%%%%%
TCR_cluster_density = 1000;
TCR_r1 = 0;
TCR_r2 = 0.25; % microns
pixel_size = 10; % nm

depletion_range_nm = 80;

CD45_cluster_density = 1000;
CD45_r1 = TCR_r2 + depletion_range_nm/1000; % nm
CD45_r2 = CD45_r1 + 0.3; % nm 0.3

%%% create TCR and CD45 locations: %%%%%%%%%%%%%%
%% TCR: 
[TCR_x_pixels0,TCR_y_pixels0] = radialDistributionArray(...
    TCR_cluster_density,TCR_r1,TCR_r2,pixel_size,...
    array_size_x_microns,array_size_y_microns);
TCR_x_pixels = TCR_x_pixels0;% - 100*array_size_x_microns/1;
TCR_y_pixels = TCR_y_pixels0;% - 100*array_size_y_microns/1;

 %% CD45:
[CD45_x_pixels0,CD45_y_pixels0] = radialDistributionArray(...
    CD45_cluster_density,CD45_r1,CD45_r2,pixel_size,...
    array_size_x_microns,array_size_y_microns);
CD45_x_pixels = CD45_x_pixels0;% - 100*array_size_x_microns/1;
CD45_y_pixels = CD45_y_pixels0;% - 100*array_size_y_microns/1;

%% read results: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('C:\Users\yairn\OneDrive\Documents\MATLAB\metamodeling\model3_2\Results');
% runs data:
hist_model3_results = dlmread('TCR_hist_model3.m');
phist_model3_results = dlmread('pTCR_hist_model3.m');
rhist_model3_results = dlmread('rTCR_hist_model3.m');

% sample data:
sample_dep_ind = 10; % 750 nm
sample_dl_ind = 4; % 100 nm

% sample_hist_model3_results
%% plot TCR and CD45 location %%%%%%%%%
axis_off = 1;

figure(10)
clf
subplot(2,3,1)
% spy(TCR_locations_array)
plot(TCR_x_pixels,TCR_y_pixels,'.','Color',TCR_color,...
    'MarkerSize',1)
hold on
plot(CD45_x_pixels,CD45_y_pixels,'.','Color',CD45_color,...
    'MarkerSize',1)
hold off
% legend('TCR','CD45')
axis equal
axis([0 s_pixels 0 s_pixels])
xticks([0:s_pixels/2:s_pixels])
yticks([0:s_pixels/2:s_pixels])
xticklabels({10*[0:s_pixels/2:s_pixels]})
yticklabels({10*[0:s_pixels/2:s_pixels]})
xlabel('x(nm)')
ylabel('y(nm)')
if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end
%% decay_disk: %%%%%%%%%%%%%%%%%%%%%%%%
% lambda = 0.01; % 1/nm
x_pixels = -100:1:100;
R_max = 100;

%%% CD45 decay:
CD45_decay_length_nm = 10;

CD45_double_decay = model3DoubleDecay(...
    CD45_decay_length_nm, pixel_size, x_pixels);
norm_CD45_double_decay = CD45_double_decay/sum(CD45_double_decay);

CD45_decay_disk = decayDisk(...
    CD45_decay_length_nm,pixel_size,R_max);
norm_CD45_decay_disk = CD45_decay_disk/sum(sum(CD45_decay_disk));

%%% aLck decay:
aLck_decay_length_nm = 80; %100;

aLck_double_decay = model3DoubleDecay(...
    aLck_decay_length_nm, pixel_size, x_pixels);
norm_aLck_double_decay = aLck_double_decay/sum(aLck_double_decay);

aLck_decay_disk = decayDisk(...
    aLck_decay_length_nm,pixel_size,R_max);
norm_aLck_decay_disk = aLck_decay_disk/sum(sum(aLck_decay_disk));

%%% sum of decays:
sum_norm_double_decay = norm_aLck_double_decay - norm_CD45_double_decay;
sum_norm_double_decay(sum_norm_double_decay < 0) = 0;

sum_norm_decay_disk = norm_aLck_decay_disk - norm_CD45_decay_disk;
sum_norm_decay_disk(sum_norm_decay_disk < 0) = 0;

%% plot decay line %%%%%%%%%%%%%%%%%%%%
% figure(9)
subplot(2,3,2)
plot(x_pixels, norm_CD45_double_decay, '-', 'Color',CD45_color,...
    'LineWidth',1)
hold on
plot(x_pixels, norm_aLck_double_decay, '-', 'Color',aLCK_color,...
    'LineWidth',1)
%%% gradient color:
xx = [x_pixels;x_pixels];
yy = [sum_norm_double_decay;sum_norm_double_decay];
zz = zeros(size(yy));
cc = yy;
% 'EdgeColor','flat', 
h = surface(xx, yy, zz, cc, 'EdgeColor','flat',...
    'FaceColor','none',...
    'LineWidth',3);
%%%
% CD45 line:
plot([0,0],[0,0.1],'-','Color',CD45_color,'LineWidth',4)
hold off

xlim([-40, 40])
ylim([0, 0.15])
xticks([-40:20:40])
xticklabels({10*[-40:20:40]})
xlabel('x(nm)')
axis square
if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end

%% plot decay_disk %%%%%%%%%%%%%%%%%%%%
Nc = 64;
% cyan_blue_colormap = cyanBlueColormap(Nc);
orange_blue_colormap = orangeBlueColormap(Nc);

% figure(9)
subplot(2,3,3)
scatter(101.5,101.5,10,'MarkerFaceColor',[1.0 0.0 0.0],...
    'MarkerEdgeColor','none')
hold on
h1 = surf(sum_norm_decay_disk-1);
hold off

h1.EdgeColor = 'none';
h1.FaceAlpha = 1.0;
colormap(orange_blue_colormap)
axis tight
axis equal

axis([61 141 61 141])
xticks([61:20:141])
yticks([61:20:141])
xticklabels({10*[-40:20:40]})
yticklabels({10*[-40:20:40]})
xlabel('x(nm)')
ylabel('y(nm)')
% axis off
% view(-30,65)
view(2)
if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end

%% aLck_probability_array %%%%%%%%%%%%%
% aLck_probability_array = aLckProbabilityArray(...
%     norm_aLck_decay_disk,array_size_x_pixels,array_size_y_pixels,...
%     CD45_x_pixels,CD45_y_pixels);
decay_probability_array = aLckProbabilityArray(...
    sum_norm_decay_disk,array_size_x_pixels,array_size_y_pixels,...
    CD45_x_pixels,CD45_y_pixels);

%%% plot surf(aLck_probability_array)
% figure(9)
subplot(2,3,4)
plot(CD45_x_pixels,CD45_y_pixels,'.','Color',CD45_color,...
    'MarkerSize',1)
hold on
plot(TCR_x_pixels,TCR_y_pixels,'.','Color',TCR_color,...
    'MarkerSize',1)

h2 = surf(decay_probability_array-1);
hold off

h2.EdgeColor = 'none';
h2.FaceAlpha = 1.0;
colormap(orange_blue_colormap)

axis([0 s_pixels 0 s_pixels])
axis tight
axis equal
xticks([0:s_pixels/2:s_pixels])
yticks([0:s_pixels/2:s_pixels])
xticklabels({10*[0:s_pixels/2:s_pixels]})
yticklabels({10*[0:s_pixels/2:s_pixels]})
xlabel('x(nm)')
ylabel('y(nm)')
axis on
% view(-30,65)
view(2)
if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end

%% locations to array: %%%%%%%%%%%%%%%%
%%% TCR_locations_array:
TCR_locations_array = zeros(array_size_x_pixels,...
    array_size_x_pixels);
linind_TCR = sub2ind(size(TCR_locations_array),...
    TCR_x_pixels,TCR_y_pixels);
TCR_locations_array(linind_TCR) = 1;

%%% pTCR_probability_array:
pTCR_probability_array = decay_probability_array.*...
    TCR_locations_array;
%% TCR phosphorylation hist %%%%%%%%%%%
TCR_normalized_counts  = sumOverRings(TCR_locations_array);
pTCR_normalized_counts = sumOverRings(pTCR_probability_array);
rTCR_normalized_counts = pTCR_normalized_counts./...
    TCR_normalized_counts;
rTCR_normalized_counts(isnan(rTCR_normalized_counts)) = 0;
rTCR_normalized_counts(1)
%%%
% M_x_40_pairs = reshape(repmat(1:40,2,1),1,80);
% y_40 = pTCR_normalized_counts(1:40);
% y_40_pairs = reshape(repmat(y_40',2,1),1,80);
% y0_40_pairs = zeros(1,80);
% M_y_40_pairs = [y_40_pairs;y0_40_pairs];
% patch_x = [M_x_40_pairs(1,2:end)-1,40,1];
% patch_y = [M_y_40_pairs(1,1:end-1),0,0];
% c = patch_y;

%%%
% figure(9)
subplot(2,3,5)
h3 = pcolor(pTCR_probability_array');
h3.EdgeColor = 'none';

axis equal
axis tight
axis([0.3*s_pixels 0.7*s_pixels 0.3*s_pixels 0.7*s_pixels])
xticks([0.3*s_pixels:40:0.7*s_pixels])
yticks([0.3*s_pixels:40:0.7*s_pixels])
xticklabels({10*[0.3*s_pixels:40:0.7*s_pixels]})
yticklabels({10*[0.3*s_pixels:40:0.7*s_pixels]})
xlabel('x(nm)')
ylabel('y(nm)')

if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end

%%
%%%
% figure(10)
subplot(2,3,6)
rTCR_normalized_counts(1) = rTCR_normalized_counts(2);
rTCR_normalized_counts(3) = 0.0083;
rTCR_normalized_counts(4) = 0.0085;
double_rTCR_normalized_counts = ...
    [fliplr(rTCR_normalized_counts'),...
    rTCR_normalized_counts(1),...
    rTCR_normalized_counts'];
% bar(1:100,1*rTCR_normalized_counts,0.9,'FaceColor', pTCR_color)
bar(-100:100,1*double_rTCR_normalized_counts,0.9,'FaceColor', pTCR_color)

axis([-40 40 0 0.04])
axis square
xticks([0:10:40])
xticklabels({10*[0:10:40]})
xlabel('r(nm)')

if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end
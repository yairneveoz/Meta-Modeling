% model3_plot_1x3
clc
%% molecules colors:
TCR_color  = [0.0, 0.6, 0.0];
CD45_color = [1.0, 0.0, 0.0];
aLCK_color = [1.0, 0.0, 1.0];
pTCR_color = [1.0, 0.7, 0.0];

orange_blue_colormap = orangeBlueColormap(64);
% map = colormap(orange_blue_colormap);
%% array size:
s_pixels = 200;
limits1 = [0 s_pixels 0 s_pixels];
array_size_x_pixels = 200;
array_size_y_pixels = 200;
array_size_x_microns = array_size_x_pixels/100;
array_size_y_microns = array_size_y_pixels/100;
pixel_size = 10; % nm
%% generate TCR and CD45 locations: %%%%%%%%%%%%%
%% TCR_locations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TCR_cluster_density = 1000;
TCR_r1 = 0;
TCR_r2 = 0.25; % microns


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

%%% TCR_locations_array:
TCR_locations_array = zeros(array_size_x_pixels,...
    array_size_x_pixels);
linind_TCR = sub2ind(size(TCR_locations_array),...
    TCR_x_pixels,TCR_y_pixels);
TCR_locations_array(linind_TCR) = 1;

 %% CD45:
[CD45_x_pixels0,CD45_y_pixels0] = radialDistributionArray(...
    CD45_cluster_density,CD45_r1,CD45_r2,pixel_size,...
    array_size_x_microns,array_size_y_microns);
CD45_x_pixels = CD45_x_pixels0;% - 100*array_size_x_microns/1;
CD45_y_pixels = CD45_y_pixels0;% - 100*array_size_y_microns/1;

%%% CD45_locations_array:
CD45_locations_array = zeros(array_size_x_pixels,...
    array_size_x_pixels);
linind_CD45 = sub2ind(size(CD45_locations_array),...
    CD45_x_pixels,CD45_y_pixels);
CD45_locations_array(linind_CD45) = 1;

%% cross section TCR and CD45: %%%%%%%%
%%% TCR:
TCR_normalized_counts  = sumOverRings(TCR_locations_array);
TCR_normalized_counts(3) = 0.5*(TCR_normalized_counts(2)+...
    TCR_normalized_counts(4));
TCR_normalized_counts(1) = 0.5*(TCR_normalized_counts(2)+...
    TCR_normalized_counts(3));

double_TCR_normalized_counts = ...
    [fliplr(TCR_normalized_counts'),...
    TCR_normalized_counts(1),...
    TCR_normalized_counts'];

%%% CD45:
CD45_normalized_counts  = sumOverRings(CD45_locations_array);
double_CD45_normalized_counts = ...
    [fliplr(CD45_normalized_counts'),...
    CD45_normalized_counts(1),...
    CD45_normalized_counts'];

%% decay_disk of one CD45: %%%%%%%%%%%%
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

aLck_decay_disk = decayDisk(...
    aLck_decay_length_nm,pixel_size,R_max);
norm_aLck_decay_disk = aLck_decay_disk/sum(sum(aLck_decay_disk));

%%% sum of decays:
sum_norm_decay_disk = norm_aLck_decay_disk - norm_CD45_decay_disk;
sum_norm_decay_disk(sum_norm_decay_disk < 0) = 0;

%%% radial sum one disk: %%%%%%%%%%%%%%%%%%%%%%%%%
sum_norm_decay_disk_normalized_counts = sumOverRings(sum_norm_decay_disk);
double_aLck_decay_disk_normalized_counts = ...
    [fliplr(sum_norm_decay_disk_normalized_counts'),...
    sum_norm_decay_disk_normalized_counts(1),...
    sum_norm_decay_disk_normalized_counts'];

%% aLck_probability_array %%%%%%%%%%%%%
decay_probability_array = aLckProbabilityArray(...
    sum_norm_decay_disk,array_size_x_pixels,array_size_y_pixels,...
    CD45_x_pixels,CD45_y_pixels);

%%
decay_normalized_counts = sumOverRings(decay_probability_array);
double_decay_normalized_counts = ...
    [fliplr(decay_normalized_counts'),...
    decay_normalized_counts(1),...
    decay_normalized_counts'];

%% locations to array: %%%%%%%%%%%%%%%%
%%% pTCR_probability_array:
pTCR_probability_array = decay_probability_array.*...
    TCR_locations_array;

%%% TCR phosphorylation hist %%%%%%%%%%%
% TCR_normalized_counts  = sumOverRings(TCR_locations_array);
pTCR_normalized_counts = sumOverRings(pTCR_probability_array);
rTCR_normalized_counts = pTCR_normalized_counts./...
    TCR_normalized_counts;
rTCR_normalized_counts(isnan(rTCR_normalized_counts)) = 0;
% rTCR_normalized_counts(1)
%%%
% M_x_40_pairs = reshape(repmat(1:40,2,1),1,80);
% y_40 = pTCR_normalized_counts(1:40);
% y_40_pairs = reshape(repmat(y_40',2,1),1,80);
% y0_40_pairs = zeros(1,80);
% M_y_40_pairs = [y_40_pairs;y0_40_pairs];
% patch_x = [M_x_40_pairs(1,2:end)-1,40,1];
% patch_y = [M_y_40_pairs(1,1:end-1),0,0];
% c = patch_y;

%%
figure(18)
clf
set(gcf, 'Units', 'pixels',...
        'OuterPosition', [200, 50, 900, 600]);
    
axis_off = 1;
gapx0 = 0.12;
gapy0 = 0.125;
gapx = 0.03;
gapy = 0.02;
sx = 0.26;
sy1 = 0.5;
sy2 = 0.25;

% origins of the individual subplots:
ox = gapx0 + [0, 1*(sx+gapx), 2*(sx+gapx)];
oy = gapy0 + [0, 1*(sy2+gapy)];

pos1 = ([ox(1), oy(3-1), sx, sy1]);
pos2 = ([ox(2), oy(3-1), sx, sy1]);
pos3 = ([ox(3), oy(3-1), sx, sy1]);
pos4 = ([ox(1), oy(3-2), sx, sy2]);
pos5 = ([ox(2), oy(3-2), sx, sy2]);
pos6 = ([ox(3), oy(3-2), sx, sy2]);
   
    
%% subplot(2,3,1)
%%% plot TCR and CD45 location %%%%%%%%%
h(1) = subplot('Position',pos1);
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


%% subplot(2,3,4)
h(4) = subplot('Position',pos4);

bar(-100:1:100,double_TCR_normalized_counts,0.9,...
    'FaceColor',TCR_color,'EdgeColor','none')
hold on
bar(-100:1:100,double_CD45_normalized_counts,0.9,...
    'FaceColor',CD45_color,'EdgeColor','none')
hold off

axis([-100 100 0 0.2])
% axis square
xticks([-100:50:10])
xticklabels({10*[-100:50:10]})
xlabel('x(nm)')

if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot decay_disk %%%%%%%%%%%%%%%%%%%%

% figure(5)
% clf
% set(gcf, 'Units', 'pixels',...
%         'OuterPosition', [200, 100, 300, 600]);

sx7 = 0.8;

pos7 = ([gapx0, gapy0+sy2+gapy, sx7, sy1]);
pos8 = ([gapx0, gapy0, sx7, sy2]);

% h(7) = subplot('Position',pos7);
% sp7 = surf(sum_norm_decay_disk);
% sp7.EdgeColor = 'none';
% colormap(orange_blue_colormap);
% view(2)
% axis equal
% axis tight
if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end


% h(8) = subplot('Position',pos8);
% bar([-101:101],double_aLck_decay_disk_normalized_counts,...
%     1,'FaceColor',pTCR_color)
% axis([-101 101 0 0.001])

% xticks([-100:50:100])
% yticks([0:s_pixels/2:s_pixels])
% xticklabels({10*[-100:50:100]})
% yticklabels({10*[0:s_pixels/2:s_pixels]})
if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end


%% subplot(2,3,2)
%%% plot surf(aLck_probability_array)
h(2) = subplot('Position',pos2);
sp2 = surf(decay_probability_array-1);
hold off

sp2.EdgeColor = 'none';
sp2.FaceAlpha = 1.0;
% colormap(orange_blue_colormap)


axis([0 s_pixels 0 s_pixels])
xticks([0:s_pixels/2:s_pixels])
yticks([0:s_pixels/2:s_pixels])
xticklabels({10*[0:s_pixels/2:s_pixels]})
yticklabels({10*[0:s_pixels/2:s_pixels]})
xlabel('x(nm)')
ylabel('y(nm)')
axis tight
axis equal
axis on
% view(-30,65)
view(2)
if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end


%% subplot(2,3,5)
h(5) = subplot('Position',pos5);

bar(-100:1:100,double_decay_normalized_counts,0.9,...
    'FaceColor',pTCR_color,'EdgeColor','none')


axis([-100 100 0 0.2])
% axis square
xticks([-100:50:10])
xticklabels({10*[-100:50:10]})
xlabel('x(nm)')

if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end

%% subplot(2,3,3)
h(3) = subplot('Position',pos3);

sp3 = pcolor(pTCR_probability_array');
sp3.EdgeColor = 'none';

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

%% subplot(2,3,6)
h(6) = subplot('Position',pos6);

rTCR_normalized_counts(1) = rTCR_normalized_counts(2);
rTCR_normalized_counts(3) = 0.0083;
rTCR_normalized_counts(4) = 0.0085;
double_rTCR_normalized_counts = ...
    [fliplr(rTCR_normalized_counts'),...
    rTCR_normalized_counts(1),...
    rTCR_normalized_counts'];
bar(-100:100,1*double_rTCR_normalized_counts,0.9,'FaceColor', pTCR_color)

axis([-40 40 0 0.04])
% axis square
xticks([0:10:40])
xticklabels({10*[0:10:40]})
xlabel('r(nm)')

if axis_off
    set(gca,'xtick',[],'ytick',[])
    set(gca,'xlabel',[],'ylabel',[])
end
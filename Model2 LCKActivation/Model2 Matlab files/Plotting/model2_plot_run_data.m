% plot_run_data
[LCK_fx, LCK_fy, LCK_fs] = find(LCK_active_location_array_sum);
figure(16)
clf
Xedges = 0:1:200;
Yedges = 0:1:200;
% h = histogram2(LCK_x_locations_pixels, LCK_y_locations_pixels,...
%     Xedges,Yedges);
aLCK_color_alpha = [1.0 0.5 1.0 0.2];
hold on
% bar3(10*LCK_active_location_array_sum)
for ind1 = 1:length(LCK_fx)
    plot3([100, 100], [100, 100], [0, 60], '-',...
        'LineWidth',4, 'Color', 'r');
    xx = LCK_fx(ind1);
    yy = LCK_fy(ind1);
    zz = LCK_fs(ind1);
    h1 = plot3([xx, xx], [yy, yy], [0, 1*zz], '-',...
        'LineWidth', 2, 'Color', aLCK_color_alpha);
%     h1.Color(4) = 0.4;
    
end
hold off
axis([0 200 0 200])
box on
view(-20,25)
%%

figure(17)
% spy(LCK_active_location_array_sum)
% surf(LCK_active_location_array_sum)
[LCK_fx, LCK_fy, LCK_fs] = find(LCK_active_location_array_sum);
% h = histogram2(LCK_fx, LCK_fy,Xedges,Yedges);
h = bar3(LCK_active_location_array_sum);

% magenta_colormap = [1.0 0.5 1.0
%                     0.0 0.0 0.5];
colormap = ([1.0 0.5 1.0; 0.0 0.0 0.5]);
set(h, 'EdgeColor','none')
axis([0 200 0 200])

%%
figure(18)

r = 1:R_max;
aLck_hist = normalized_sum_values_on_rings(2:end);
sum_hist = sum(aLck_hist);
smr = 1;

bar_aLCK = bar(r(2:end)-0.5,aLck_hist);
bar_aLCK.FaceColor = parameters.molecules.aLCK.color(1:3);
bar_aLCK.EdgeColor = parameters.molecules.aLCK.color(1:3);
bar_aLCK.FaceAlpha = 1;

% hold on
% scale = 11;
% plot(r,(sum_hist/scale)*exp(-r/scale), 'r-')
% hold off
xlabel('radius(pixels)')
ylabel('counts normalized to rings areas')

axis square
axis tight
axis([0 100 0 150])



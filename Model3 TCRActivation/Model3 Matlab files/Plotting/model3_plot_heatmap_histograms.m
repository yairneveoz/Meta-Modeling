% model3_heatmap_histograms_plot
clc
%% read data:
% read rTCR historgrams 3D array:
rTCR_hist_model3_3D = load('rTCR_hist_model3_fine2');
rTCR_hist_model3 = ...
    rTCR_hist_model3_3D.dep_decay_rTCR_normalized_counts;

% asign NaN to 0:
rTCR_hist_model3(isnan(rTCR_hist_model3)) = 0;

%% calculate heatmaps:
[rTCR_mean_array,rTCR_Exp_array] = ...
    rTCRhist2MeanExp('rTCR_hist_model3_fine2');
%% save rTCR_mean_array, rTCR_Exp_array:
% rTCR_Exp_array:
% dlmwrite('rTCR_Exp_array.m',rTCR_Exp_array);
% dlmwrite('rTCR_Exp_array',rTCR_Exp_array);
% dlmwrite('rTCR_Exp_array.npy',rTCR_Exp_array);
% 
% % rTCR_mean_array:
% dlmwrite('rTCR_mean_array.m',rTCR_mean_array);
% dlmwrite('rTCR_mean_array',rTCR_mean_array);
% dlmwrite('rTCR_mean_array.npy',rTCR_mean_array);

%% define locations and names for sample data:
samples_data = makeSamplesDataLines();
%% plot rTCR_Exp heatmap:

dep_indices = 1:size(rTCR_mean_array,1);
dec_indices = 1:size(rTCR_mean_array,2);

dep_values = 10*(dep_indices-1); % nm
dec_values = 10*(dec_indices-1); % nm

vertical_heatmaps = 1;
horizontalal_heatmaps = 0;
figure(9)
clf
%% vertical heatmaps %%%%%%%%%%%%%%%%%%
if vertical_heatmaps
    set(gcf, 'Units', 'pixels',...
            'OuterPosition', [50, 50, 500, 800]);

    %%% subplot(2,1,1) sizes:
    o1x = 0.1;
    o1y = 0.55;
    s1x = 0.8;
    s1y = 0.40;
    pos1 = ([o1x, o1y, s1x, s1y]);
    h1 = subplot('Position',pos1);

    pcolor(10*rTCR_Exp_array)
    colorbar
    hold on
    [~,c1] = contour(10*rTCR_Exp_array);
    hold off
    c1.LineColor = [1, 1, 1];
    caxis([0 250])
    title('Expectation value of rTCR')
    % xlabel('Decay length (nm)')
    ylabel('Depletion (nm)')
    % xticks(1:5:length(dec_values))
    yticks(0:5:length(dep_values))
    % xticklabels(10*[0:5:length(dec_values)])
    yticklabels(10*[0:5:length(dep_values)])
    xticks([])
    % yticks([])

    axis equal
    axis tight
    axis([2 20 1 20])

    pcolor(10*rTCR_Exp_array)
    colorbar
    hold on
    [~,c1] = contour(10*rTCR_Exp_array);
    hold off
    c1.LineColor = [1, 1, 1];
    caxis([0 250])
    title('Expectation value of rTCR')
    % xlabel('Decay length (nm)')
    ylabel('Depletion (nm)')
    % xticks(1:5:length(dec_values))
    yticks(0:5:length(dep_values))
    % xticklabels(10*[0:5:length(dec_values)])
    yticklabels(10*[0:5:length(dep_values)])
    xticks([])
    % yticks([])

    axis equal
    axis tight
    axis([2 20 1 20])

    % samples anotations:
    for s1 = 1:length(samples_data)
        idep = 0.1*samples_data(s1).dep;
        idec = 0.1*samples_data(s1).dec;
        iname = samples_data(s1).name;

        hold on
        text(idec+0.5,idep+0.5,iname,'Color',[1.0, 1.0, 1.0],...
        'FontWeight', 'Bold','HorizontalAlignment','Center')
        hold off
    end

    %% plot mean_rTCR heatmap
    sum_rTCR_heatmap = sum(rTCR_hist_model3,3);
   
    o2x = 0.1;
    o2y = 0.1;
    s2x = 0.8;
    s2y = 0.4;
    pos2 = ([o2x, o2y, s2x, s2y]);
    h2 = subplot('Position',pos2);

    pcolor(10*rTCR_mean_array)
    colorbar
    hold on
    [~,c1] = contour(10*rTCR_mean_array);
    hold off
    c1.LineColor = [1, 1, 1];
    caxis([0 0.45])
    title('Mean of rTCR histogram')
    xlabel('Decay length (nm)')
    ylabel('Depletion (nm)')
    xticks(0:5:length(dec_values))
    yticks(0:5:length(dep_values))
    xticklabels(10*[0:5:length(dec_values)])
    yticklabels(10*[0:5:length(dep_values)])

    % xticks([])
    % yticks([])
    % xt
    axis equal
    axis tight
    axis([2 20 1 20])

    % samples anotations:
    for s1 = 1:15
        idep = 0.1*samples_data(s1).dep;
        idec = 0.1*samples_data(s1).dec;
        iname = samples_data(s1).name;

        hold on
        text(idec+0.5,idep+0.5,iname,'Color',[1.0, 1.0, 1.0],...
        'FontWeight', 'Bold','HorizontalAlignment','Center')
        hold off
    end


%% horizontal heatmaps %%%%%%%%%%%%%%%%
    figure(19)

    set(gcf, 'Units', 'pixels',...
            'OuterPosition', [50, 50, 800, 500]);

    o1x = 0.1;
    o1y = 0.15;
    s1x = 0.4;
    s1y = 0.8;
    pos1 = ([o1x, o1y, s1x, s1y]);
    h1 = subplot('Position',pos1);

    pcolor(10*rTCR_Exp_array)
    colorbar
    hold on
    [~,c1] = contour(10*rTCR_Exp_array);
    hold off
    c1.LineColor = [1, 1, 1];
    caxis([0 250])
    title('Mean radial distance')
    xlabel('Decay length (nm)')
    ylabel('Depletion (nm)')
    xticks(0:5:length(dec_values))
    yticks(0:5:length(dep_values))
    xticklabels(10*[0:5:length(dec_values)])
    yticklabels(10*[0:5:length(dep_values)])

    axis equal
    axis tight
    axis([2 20 1 20])

    % samples anotations:
    for s1 = 1:length(samples_data)
        idep = 0.1*samples_data(s1).dep;
        idec = 0.1*samples_data(s1).dec;
        iname = samples_data(s1).name;

        hold on
        text(idec+0.5,idep+0.5,iname,'Color',[1.0, 1.0, 1.0],...
        'FontWeight', 'Bold','HorizontalAlignment','Center')
        hold off
    end

    %%% plot mean_rTCR heatmap
    sum_rTCR_heatmap = sum(rTCR_hist_model3,3);

    o2x = 0.55;
    o2y = 0.15;
    s2x = 0.4;
    s2y = 0.8;
    pos2 = ([o2x, o2y, s2x, s2y]);
    h2 = subplot('Position',pos2);

    pcolor(10*rTCR_mean_array)
    colorbar
    hold on
    [~,c1] = contour(10*rTCR_mean_array);
    hold off
    c1.LineColor = [1, 1, 1];
    caxis([0 0.45])
    title('Mean relative TCR*')
    xlabel('Decay length (nm)')
%     ylabel('Depletion (nm)')
    xticks(0:5:length(dec_values))
%     yticks(0:5:length(dep_values))
    xticklabels(10*[0:5:length(dec_values)])
%     yticklabels(10*[0:5:length(dep_values)])

    % xticks([])
    yticks([])
    % xt
    axis equal
    axis tight
    axis([2 20 1 20])

    % samples anotations:
    for s1 = 1:15
        idep = 0.1*samples_data(s1).dep;
        idec = 0.1*samples_data(s1).dec;
        iname = samples_data(s1).name;

        hold on
        text(idec+0.5,idep+0.5,iname,'Color',[1.0, 1.0, 1.0],...
        'FontWeight', 'Bold','HorizontalAlignment','Center')
        hold off
    end
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot rTCR histograms accordind to heatmap coordinates:
model3plotrTCRHistSubplots(5,3,samples_data,rTCR_hist_model3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot Points Subplots: %%%%%%%%%%%%%%
model3plotPointsSubplots(5,3,samples_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot Clouds Subplots: %%%%%%%%%%%%%%
model3plotCloudsSubplots(5,3,samples_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% contours:
% v = [0.0005:0.0005:0.003];
% [h2,c2] = contour(rTCR_max_diff_heatmap,v,'ShowText','on');
% c2.LineColor = [1, 1, 1];
% 
% smooth conours:
% newpoints = 100;
% [xq,yq] = meshgrid(...
%             linspace(min(min(xrow,[],2)),max(max(xrow,[],2)),newpoints ),...
%             linspace(min(min(ycol,[],1)),max(max(ycol,[],1)),newpoints )...
%           );
% BDmatrixq = interp2(xrow,ycol,BDmatrix,xq,yq,'cubic');
% [c,h]=contourf(xq,yq,BDmatrixq);



function model3plotZonesrTCRHistSubplots(Nrows,Ncols,...
    samples_data,rTCR_hist_model3)

% subplots and gaps sizes (relative to the figure size):
gapx0 = 0.12;
gapy0 = 0.125;
gapx = 0.03;
gapy = 0.02;
sx = 0.26;
sy = 0.14;

% origins of the individual subplots:
ox = gapx0 + [0, 1*(sx+gapx), 2*(sx+gapx)];
oy = gapy0 + [0, 1*(sy+gapy), 2*(sy+gapy),...
                 3*(sy+gapy), 4*(sy+gapy)];

r = 1:size(rTCR_hist_model3,3);
boxx = [0 1 1 0];
boxy = [0 0 1 1];
alphas = 0.5;
figure(11)
clf
set(gcf, 'Units', 'pixels',...
        'OuterPosition', [700, 50, 500, 800]);
% clf
 for s2 = 1:Ncols*Nrows
    %%%%%%%%%%%%%%%%%%%%%%
    % s2 to row index: 
    col_ind = ceil(s2/Nrows);
    % s2 to column index: 
    row_ind = 1+mod(s2+4,Nrows); 

    % index of depletion value:
    idep = 0.1*samples_data(s2).dep;
    % index of decay_length value:
    idec = 0.1*samples_data(s2).dec;
    % name (letter) of point
    iname = samples_data(s2).name;
        
    pos1 = ([ox(col_ind), oy(6-row_ind), sx, sy]);
    h(s2) = subplot('Position',pos1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% plot TCR range:
    TCR_x = 25;
    TCR_y = 0.1;
    p1 = patch(2*TCR_x*boxx - TCR_x,TCR_y*boxy,[0.0, 0.6, 0.0]);
    p1.FaceAlpha = alphas;
    p1.EdgeColor = 'none';
    hold on
    
    %% plot CD45 range:
    CD45_w = 50;
    CD45_x = TCR_x + 10*(idep-1);
    CD45_y = TCR_y;
    p2 = patch(CD45_w*boxx + CD45_x, CD45_y*boxy,...
        [1.0, 0.0, 0.0]);
    p2.FaceAlpha = alphas;
    p2.EdgeColor = 'none';
    p3 = patch(-(CD45_w*boxx + CD45_x), CD45_y*boxy,...
        [1.0, 0.0, 0.0]);
    p3.FaceAlpha = alphas;
    p3.EdgeColor = 'none';
    
    %% plot aLck decay:
    dec_x_max = 1*5*idec; %10
    dec_x = [0:dec_x_max/20:dec_x_max];
    decay_x = [dec_x,dec_x(end),dec_x(1)];
%     decay_y = [exp(-dec_x/(10*idec)),0,0];
    decay_y = 1/(1*(idec-1))*[exp(-dec_x/(1*(idec-1))),0,0];
    %% d1
    aLck_y = 1;
    d1 = patch(CD45_x + CD45_w/1 + decay_x,...
        aLck_y*decay_y,[1.0, 0.0, 1.0]);
    d1.FaceAlpha = alphas;
    d1.EdgeColor = 'none';
    %% d2
    d2 = patch(CD45_x + 0*CD45_w/1 - decay_x,...
        aLck_y*(decay_y),[1.0, 0.0, 1.0]);
    d2.FaceAlpha = alphas;
    d2.EdgeColor = 'none';
    %% d3
    d3 = patch(-CD45_x - 0*CD45_w/1 + decay_x,...
        aLck_y*decay_y,[1.0, 0.0, 1.0]);
    d3.FaceAlpha = alphas;
    d3.EdgeColor = 'none';
    %% d2
    d4 = patch(-CD45_x - CD45_w/1 - decay_x,...
        aLck_y*(decay_y),[1.0, 0.0, 1.0]);
    d4.FaceAlpha = alphas;
    d4.EdgeColor = 'none';

    %% 3D array to 1D:
    rTCR_hist = squeeze(rTCR_hist_model3(idep,idec,:));
    rr2 = [-fliplr(r),0,r];
    rTCR_hist2 = [flipud(rTCR_hist);0;rTCR_hist];
    rTCR_hist2(length(r)-2:1:length(r)+2) = ...
        rTCR_hist(2);
    
    % bar plot:
    bar(rr2, rTCR_hist2,1,'FaceColor',[1.0, 0.6, 0],...
        'EdgeColor','none')    
    %% mark Exp and Mean %%%%%%%%%%%%%%%%%%%%
    % rTCR_Exp:
    rTCR_Exp = sum(rTCR_hist.*r')/sum(rTCR_hist);

    % rTCR_mean:
    % TODO: fix this (25-1)
    rTCR_mean = sum(rTCR_hist)/(25-1); % !!!

%     hold on
    % plot location of 
%     plot([rTCR_Exp rTCR_Exp],...
%          [rTCR_mean-0.006 rTCR_mean+0.006],'-',...
%          'Color',[1.0, 0.0, 0.0],'LineWidth',1)
%     plot([rTCR_Exp-4 rTCR_Exp+4],...
%          [rTCR_mean rTCR_mean],'-',...
%          'Color',[0.0, 0.6, 0.0],'LineWidth',1)

    plot(rTCR_Exp,rTCR_mean,'+',...
        'Color',[0, 0, 1],'LineWidth',1)
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hold off
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    text(-27,0.05,iname,'FontWeight', 'Bold')
%     xlim([-29.9 30])
    xlim([-200 200])
    ylim([0 0.1])
    xticks([-30:30:30]);
    xticklabels(10*[-30:30:30])

%     xticks([]);
%     yticks([]);
 end

% delete XTickLabels:
set([h(1),h(2),h(3),h(4)],'XTickLabel','');
set([h(6),h(7),h(8),h(9)],'XTickLabel','');
set([h(11),h(12),h(13),h(14)],'XTickLabel','');
% delete YTickLabels:
set([h(6),h(7),h(8),h(9),h(10),...
     h(11),h(12),h(13),h(14),h(15)],'YTickLabel','');

%     yticks([0 0.1 0.2])
%     if ismember(s2,[13,14,15])
%         xlabel('x(nm)')
%     end
%     if ismember(s2,[1,4,7,10,13])
%         ylabel('P( )')
%     end

end
% analyze_results
model3_TCR_data = load('TCR_hist_model3.mat');
model3_pTCR_data = load('pTCR_hist_model3.mat');
model3_rTCR_data = load('rTCR_hist_model3.mat');
%%
TCR_data_3D  = model3_TCR_data.dep_decay_TCR_normalized_counts;
pTCR_data_3D = model3_pTCR_data.dep_decay_pTCR_normalized_counts;
rTCR_data_3D = model3_rTCR_data.dep_decay_rTCR_normalized_counts;
figure(9)
r = 1:size(TCR_data_3D,3);
for dep_ind = 1:size(TCR_data_3D,1)
    for dl_ind = 1:size(TCR_data_3D,2)
        disp(dep_ind)
        disp(dl_ind)

        TCR = squeeze(TCR_data_3D(dep_ind,dl_ind,:));
        pTCR = squeeze(pTCR_data_3D(dep_ind,dl_ind,:));
        rTCR = squeeze(rTCR_data_3D(dep_ind,dl_ind,:));
        
        rTCR(isnan(rTCR)) = 0;
        
%         plot(r,TCR,'.-')
%         hold on
%         plot(r,pTCR,'.-')
        plot(r,rTCR,'.-')
        title(['dep = ',num2str(dep_ind), 'dec = ',num2str(dl_ind)])
        axis([0 40 0 0.1])
%         hold off
        drawnow
        pause(0.1)
    end
end

%% diff between edges
high_ind = 25;
low_ind = 2;
rTCR_high_array = squeeze(rTCR_data_3D(:,:,high_ind));
rTCR_low_array = squeeze(rTCR_data_3D(:,:,low_ind));
rTCR_diff_array = (rTCR_high_array - rTCR_low_array)/...
    (10*(high_ind - low_ind));

%% maximum smooothed slope
model3_rTCR_data = load('rTCR_hist_model3.mat');
rTCR_data_3D = model3_rTCR_data.dep_decay_rTCR_normalized_counts;
size(rTCR_data_3D)
dep_ind = 1;
dl_ind = 1;
rTCR = squeeze(rTCR_data_3D(dep_ind,dl_ind,:));
rTCR(isnan(rTCR)) = 0;
rTCR_25 = rTCR(1:25);
diff_rTCR_25 = diff(rTCR_25);
size(diff_rTCR_25)

figure(13)
subplot(1,2,1)
plot(1:25,rTCR_25,'.-')

subplot(1,2,2)
plot(1:24,diff_rTCR_25,'.-')
hold on
plot(1:24,smooth(diff_rTCR_25,5),'.-')
hold off

max(smooth(diff_rTCR_25,5))
%% max_diff_array:
model3_rTCR_data = load('rTCR_hist_model3.mat');
rTCR_data_3D = model3_rTCR_data.dep_decay_rTCR_normalized_counts;
rTCR_data_3D(isnan(rTCR_data_3D)) = 0;

rTCR_max_diff_array = zeros(size(rTCR_data_3D,1),size(rTCR_data_3D,2));
r1 = 5;
r2 = 25;
rTCR_data_3D_r1r2 = rTCR_data_3D(:,:,r1:r2);
figure(13)
for dep_ind = 1:size(rTCR_data_3D,1)
    for dl_ind = 1:size(rTCR_data_3D,2)
        rtcr_r1r2 = rTCR_data_3D_r1r2(dep_ind,dl_ind,:);
        diff_rtcr_r1r2 = diff(rtcr_r1r2);
        smooth_diff_rtcr_r1r2 = smooth(diff_rtcr_r1r2,5);
        max_smooth_diff_rtcr_r1r2 = max(smooth_diff_rtcr_r1r2);
        rTCR_max_diff_array(dep_ind,dl_ind) = max_smooth_diff_rtcr_r1r2;
        
%         plot(r1:r2-1,smooth_diff_rtcr_r1r2,'.-')
%         ylim([0 0.02])
%         title(['max diff = ',num2str(max_smooth_diff_rtcr_r1r2)])
%         pause()
    end
end

figure(14)
surf(rTCR_max_diff_array)

%%
save('rTCR_max_diff_array.mat', 'rTCR_max_diff_array');
dlmwrite('rTCR_max_diff_array.m', rTCR_max_diff_array);
dlmwrite('rTCR_max_diff_array', rTCR_max_diff_array);
dlmwrite('rTCR_max_diff_array.npy', rTCR_max_diff_array);


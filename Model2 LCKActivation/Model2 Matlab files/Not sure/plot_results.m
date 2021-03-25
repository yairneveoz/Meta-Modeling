% plot_results
LCK_mean_step_size_nm = 1000*sqrt(4*iteration_time*LCK_Diff);

figure(2)
ymax = 8000; %2*ceil(LCK_mean_step_size_nm)*sqrt(N_steps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
steps = 1:N_steps;
subplot(2,2,1)
plot(steps, LCK_r, '.-')
hold on
plot(steps, LCK_mean_step_size_nm*sqrt(N_steps),...
    'k--', 'LineWidth',1)
hold off
title('Distance from starting point')
xlabel('Steps')
ylabel('Distance(nm)')
axis([0 N_steps 0 ymax])
%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [bincounts] = histc(LCK_paths_r(:),binranges);
% subplot(2,2,2)
% barh(binranges,bincounts,'histc')
% title('Distance from starting point')
% xlabel('Steps')
% ylabel('Distance(nm)')
% axis([0 20000 0 8000])
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot(2,2,3)
% plot(1:N_steps, LCK_active_r, '.-')
% hold on
% plot(1:N_steps, LCK_mean_step_size_nm*sqrt([1:N_steps]),...
%     'k--', 'LineWidth',1)
% hold off
% title('Distance*activeness')
% xlabel('Steps')
% ylabel('Distance(nm)')
% axis([0 N_steps 0 ymax])
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% binranges = -50:100:7000;
% % [bincounts] = histc(x,binranges);
% LCK_active_r2 = LCK_active_r;
% LCK_active_r2(LCK_active_r2 == 0) = [];
% [bincounts2] = histc(LCK_active_r2(:),binranges);
% subplot(2,2,4)
% barh(binranges,bincounts2,'histc')
% title('Distance from starting point')
% xlabel('Steps')
% ylabel('Distance(nm)')
% axis([0 8000 0 ymax])



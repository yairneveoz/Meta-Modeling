% model2_main
% LCK_activation_simulation
clc
clear
%% definitions:
parameters = defineParameters();
N_LCK = parameters.molecules.LCK.N;

%%% set pixels:
pixels = setPixels(parameters);
%% % LCK_activation_locations_array
% An array of zeros and ones. The ones define the locations
% where Lck molecules can be activated.
LCK_activation_locations_array = zeros(pixels.Nx,pixels.Ny);
LCK_activation_locations_array(...
    round(pixels.Nx/2), round(pixels.Ny/2)) = 1;

%% initial LCK locations:
LCK_Diff = 0.01; % 0.3
LCK_Poff = 0.01;
% N_steps = 1000;
R_max = ceil(pixels.Nx/2);

%%
% batch values:
log10_diff = -3:0.25:0;
log10_Poff = -5:0.5:0;
LCK_Diff_values = 10.^log10_diff; % um^2/sec
LCK_Poff_values = 10.^log10_Poff;
N_Diff = size(LCK_Diff_values,2);
N_Poff = size(LCK_Poff_values,2);
results_3D = zeros(N_Diff,N_Poff,R_max);

plot_running_data = 0;

for LCK_Diff_ind = 1:N_Diff
    LCK_Diff = LCK_Diff_values(LCK_Diff_ind);
    for LCK_Poff_ind = 1:N_Poff
        LCK_Poff = LCK_Poff_values(LCK_Poff_ind);
        disp(['Diff_ind = ',num2str(LCK_Diff_ind),...
            ', Poff_ind = ',num2str(LCK_Poff_ind)])
        run_calculation

        if plot_running_data
            plot_run_data
        end
    end
end
%%
% save('results_3D_model2.mat', 'results_3D');
% dlmwrite('results_3D_model2.m', results_3D);
% dlmwrite('results_3D_model2', results_3D);
% dlmwrite('results_3D_model2.npy', results_3D);


%% plot heatmap 
% assuming exponential distribution:
results_data = load('results_3D_model2.mat');
% dim1 = diff
% dim2 = Poff

% 3D data array;
Lck_activation_data = results_data.results_3D;

% radii
rr = [1:1:size(Lck_activation_data,3)]';
rr_nm = rr*10; % radii in nm
size_Diff = size(Lck_activation_data,1);
size_Poff = size(Lck_activation_data,2);

% define arrays for heatmaps:
aLck_scale_array  = zeros();
aLck_lambda_array = zeros();

% curve fit type:
% gaussEqn = 'a*exp(-((x-b)/c)^2)+d';
% my_exp1 = 'a*exp(-rr_nm/l_decay)';
fit_type = fittype('exp1');

for Diff_ind = 1:size_Diff
    for Poff_ind = 1:size_Poff
        % select one vector of data: 
        dd = squeeze(...
            Lck_activation_data(Diff_ind,Poff_ind,2:end));
        % finding scale and lambda from 
        % fit(rr,dd) = scale*exp(lambda*x):
        cf = fit(rr_nm(2:end), dd, fit_type,'Start',[10,-0.01]);
        scale  = cf.a;
        lambda = cf.b;

        aLck_scale_array(Diff_ind,Poff_ind)  = scale;
        aLck_lambda_array(Diff_ind,Poff_ind) = lambda;
    end
end

%%
aLck_scale_array  = zeros();
aLck_lambda_array = zeros();
figure(11)
for Diff_ind = 1:size_Diff
    for Poff_ind = 1:size_Poff
        dd = squeeze(...
            Lck_activation_data(Diff_ind,Poff_ind,2:end));
        % finding scale and lambda from 
        % fit(rr,dd) = scale*exp(lambda*x):
        cf = fit(rr_nm(2:end), dd, fit_type,'Start',[10,-0.01]);
        scale  = cf.a;
        lambda = cf.b;
        plot(rr_nm(2:end), dd, 'b.')
        fitted_curve = scale*exp(rr_nm*lambda);
        hold on
        plot(rr_nm, fitted_curve, 'r.-')
        hold off
        title(['Diff = ', num2str(Diff_ind),...
               ', Poff = ', num2str(Poff_ind)...
               's = ',num2str(scale),...
               ', l = ',num2str(lambda),...
               ' d = ', num2str(1/lambda)])
        drawnow
        pause()
        aLck_scale_array(Diff_ind,Poff_ind)  = scale;
        aLck_lambda_array(Diff_ind,Poff_ind) = lambda;
    end
end
%%
log10_diff = -3:0.25:0;
log10_Poff = -5:0.5:0;
LCK_Diff_values = 10.^log10_diff; % um^2/sec
LCK_Poff_values = 10.^log10_Poff;

figure(13)
subplot(1,2,1)
pcolor(log10_Poff, log10_diff, aLck_scale_array)
colorbar
caxis([0 1000])
title('Scale (nm)')
xlabel('log_{10}(Poff)')
ylabel('log_{10}(D)')

aLck_lambda_array2 = aLck_lambda_array;
% Lck_lambda_array2(Lck_lambda_array2 > 0.002) = -0.035;
subplot(1,2,2)
pcolor(log10_Poff, log10_diff, (-aLck_lambda_array2))
colorbar
caxis([0 0.05])
title('Exponent (nm^{-1})')
xlabel('log_{10}(Poff)')
ylabel('log_{10}(D)')

%%
aLck_decaylength_array = -1./(aLck_lambda_array2);
sm_dl = smoothdata(aLck_decaylength_array,5);

figure(17)
pcolor(log10_Poff, log10_diff, sm_dl)
colorbar
caxis([0 2000])
%%
% save('aLck_scale_array_model2.mat', 'aLck_scale_array');
% dlmwrite('aLck_scale_array_model2.m', aLck_scale_array);
% dlmwrite('aLck_scale_array_model2', aLck_scale_array);
% dlmwrite('aLck_scale_array_model2.npy', aLck_scale_array);
% 
% save('aLck_lambda_array_model2.mat', 'aLck_lambda_array');
% dlmwrite('aLck_lambda_array_model2.m', aLck_lambda_array);
% dlmwrite('aLck_lambda_array_model2', aLck_lambda_array);
% dlmwrite('aLck_lambda_array_model2.npy', aLck_lambda_array);

%% val(x) = a*exp(b*x);

tt = [1:100]';
lambda = -0.1;
dd = 50*exp(tt*lambda);

ft=fittype('exp1');
cf=fit(tt,dd,ft);
calc_curve = cf.a*exp(tt*cf.b);

figure(11)
plot(tt,dd,'ro')
hold on
plot(tt,calc_curve,'b-')
hold off

% ft=fittype('exp1');
% cf=fit(time,data,ft);


%%
dl = 500;
xx = 1:1000;
ee = exp(-xx/dl);
figure(8)
plot(xx,ee)

function [rTCR_mean_array,rTCR_Exp_array] = ...
    rTCRhist2MeanExp(file_name)

%{
input: file_name of 3D array with rTCR data.
output: 1) 2D array of mean rTCR values where the mean is
calculated only inside the TCR area.
        2) 2D array of expectation values rTCR.
%}

%{
read .mat file of a 3D array that contains the
relative rTCR (rTCR = pTCR/TCR) values as a function
of depletion, decay_length and radial distance: 
dim1: depletion.
dim2: decay_length.
dim3: radial distane in pixels.
%}

rTCR_hist_3D_file = load(file_name);
rTCR_hist_3D = ...
    rTCR_hist_3D_file.dep_decay_rTCR_normalized_counts;

% NaN to 0:
rTCR_hist_3D(isnan(rTCR_hist_3D)) = 0;

% initailize 2D results arrays:
rTCR_mean_array = zeros(size(rTCR_hist_3D,1),...
    size(rTCR_hist_3D,2));

rTCR_Exp_array = zeros(size(rTCR_hist_3D,1),...
    size(rTCR_hist_3D,2));

% radius in bin index:
r = 1:size(rTCR_hist_3D,3);
% figure(15)
for dep_ind = 1:size(rTCR_hist_3D,1)
    for dec_ind = 1:size(rTCR_hist_3D,2)
        % make 1D histogram:
        rTCR_hist = squeeze(rTCR_hist_3D(dep_ind,dec_ind,:));
        
        % assign expectation value to the 2D results arrays:
        % rTCR_Exp:
        rTCR_Exp = sum(rTCR_hist.*r')/sum(rTCR_hist);
        rTCR_Exp_array(dep_ind,dec_ind) = rTCR_Exp;
        
        % rTCR_mean:
        % TODO: fix this (25-1)
        rTCR_mean = sum(rTCR_hist)/(25-1); % !!!
        rTCR_mean_array(dep_ind,dec_ind) = rTCR_mean;
        
%         bar(r,rTCR_hist)
%         hold on
%         plot([rTCR_Exp rTCR_Exp],[0 0.3],'-')
%         plot([0 r(end)],[rTCR_mean rTCR_mean],'-')
%         hold off
%         pause(0.1)
                
    end
end

end
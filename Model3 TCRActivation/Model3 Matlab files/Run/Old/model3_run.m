% model3_run

N_dep   = length(batch_depletion_range_nm);
N_dec = length(batch_aLCK_decay_length_nm);

TCR_normalized_counts_array  =  zeros(N_samples,N_bins);
pTCR_normalized_counts_array =  zeros(N_samples,N_bins);

dep_decay_TCR_normalized_counts  = zeros(N_dep,N_dec,N_bins);
dep_decay_pTCR_normalized_counts = zeros(N_dep,N_dec,N_bins);

% N_bins = 200;
for dep_ind = 1:length(batch_depletion_range_nm)
    for dl_ind = 1:length(batch_aLCK_decay_length_nm)
        disp(dep_ind)
        disp(dl_ind)
        depletion_range_nm = batch_depletion_range_nm(dep_ind);
        decay_length_nm = batch_aLCK_decay_length_nm(dl_ind);
        
        %% decay_disk: %%%%%%%%%%%%%%%%%%%%%%%%
        decay_disk = model3_decayDisk(decay_length_nm,pixel_size,R_max);
        norm_decay_disk = decay_disk/sum(sum(decay_disk));
        
        %% CD45 ring:
        CD45_r1 = TCR_r2 + depletion_range_nm/1000; % nm
        CD45_r2 = CD45_r1 + 0.5; % nm 0.3
        
        for n = 1:N_samples
            disp(n)
            %% ramdom sampling
            %% TCR_locations %%%%%%%%%%%%%%%%%%%%%%
            [TCR_x_pixels,TCR_y_pixels] = radialDistributionArray(...
                TCR_cluster_density,TCR_r1,TCR_r2,pixel_size,...
                array_size_x_microns,array_size_y_microns);

            %% TCR_locations array %%%%%%%%%%%%%%%%
            TCR_locations_array = ...
                zeros(array_size_x_pixels,array_size_y_pixels);

            linind_TCR = sub2ind(size(TCR_locations_array),...
                TCR_x_pixels,TCR_y_pixels);

            TCR_locations_array(linind_TCR) = 1;

            %% CD45 locations %%%%%%%%%%%%%%%%%%%%%
            [CD45_x_pixels,CD45_y_pixels] = radialDistributionArray(...
                CD45_cluster_density,CD45_r1,CD45_r2,pixel_size,...
                array_size_x_microns,array_size_y_microns);

            %% aLck_probability_array %%%%%%%%%%%%%
            aLck_probability_array = aLckProbabilityArray(...
                norm_decay_disk,array_size_x_pixels,array_size_y_pixels,...
                CD45_x_pixels,CD45_y_pixels);

            %% TCR phosphorylation pattern %%%%%%%%
            pTCR_probability_array = TCR_locations_array.*aLck_probability_array;

            %% sum over angles:
            TCR_normalized_counts  = sumOverRings(TCR_locations_array);
            pTCR_normalized_counts = sumOverRings(pTCR_probability_array);
        
            TCR_normalized_counts_array(n,:)  =  TCR_normalized_counts';
            pTCR_normalized_counts_array(n,:) =  pTCR_normalized_counts';
            
        end
        mean_TCR_normalized_counts_array = ...
            mean(TCR_normalized_counts_array,1);
        mean_pTCR_normalized_counts_array = ...
            mean(pTCR_normalized_counts_array,1);
        
        %%
        figure(6)
        bar(1:length(mean_TCR_normalized_counts_array),...
            mean_TCR_normalized_counts_array)
        hold on
        bar(1:length(mean_pTCR_normalized_counts_array),...
            10*mean_pTCR_normalized_counts_array)
        hold off
        
        dep_decay_TCR_normalized_counts(dep_ind,dl_ind,:) = ...
            mean_TCR_normalized_counts_array;
        dep_decay_pTCR_normalized_counts(dep_ind,dl_ind,:) = ...
            mean_pTCR_normalized_counts_array;
            
    end
end    



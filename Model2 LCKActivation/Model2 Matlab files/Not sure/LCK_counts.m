function [LCK_r_counts, LCK_active_r_counts] = ...
    LCK_counts(LCK_r, LCK_active_r, binranges)
    
% all paths:
% [bincounts] = histc(x,binranges);
LCK_r_counts = histcounts(LCK_r(:), binranges);

% active paths:
LCK_active_r2 = LCK_active_r;
LCK_active_r2(LCK_active_r2 == 0) = [];
LCK_active_r_counts = histcounts(LCK_active_r2(:), binranges);

end




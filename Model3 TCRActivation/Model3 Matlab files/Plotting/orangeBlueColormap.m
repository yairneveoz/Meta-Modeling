function orange_blue_colormap = orangeBlueColormap(Nc)

reds   = 0:1/(Nc-1):1; 
greens = 0.6*reds; %zeros(1,Nc); 
blues  =  0.5*(1-reds); %0.6*ones(1,Nc); 

orange_blue_colormap = [reds',greens',blues'];

end
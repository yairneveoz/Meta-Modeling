function cyan_blue_colormap = cyanBlueColormap(Nc)

reds   = 0:1/(Nc-1):1; 
greens = zeros(1,Nc); 
blues  = 0.6*ones(1,Nc); 

cyan_blue_colormap = [reds',greens',blues'];

end
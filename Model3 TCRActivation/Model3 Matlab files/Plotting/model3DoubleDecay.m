function double_decay = ...
    model3DoubleDecay(decay_length,pixel_size,x_pixels)

double_decay = exp(-abs(x_pixels)/(decay_length/pixel_size));

end
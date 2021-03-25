% ring_for_model2B
figure(4)
tt = 0:2*pi/200:2*pi;

ztt = zeros(size(tt));

hold on
for rtt = 4:4:100
   plot3(rtt*cos(tt)+100,rtt*sin(tt)+100,ztt,...
       '-', 'Color', 0.7*[1 1 1], 'LineWidth',0.5) 
    
end
hold off
xticks([])
yticks([])
zticks([])
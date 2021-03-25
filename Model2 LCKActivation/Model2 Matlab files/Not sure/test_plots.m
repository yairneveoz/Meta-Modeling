% test_plots


%%
% x = (10:1000:125010)';
% y = pdf(pd,x);
% https://en.wikipedia.org/wiki/Rayleigh_distribution
xx = binranges;
yy0 = 600*sqrt(xx).*exp(-(xx/2600).^2);
NN = 33e5;
yy = 5*2*(xx)/NN.*exp(-xx.^2/NN);
pd1 = makedist('Lognormal','mu',log(2500),'sigma',1.1);
y1 = pdf(pd1,xx);
pd2 = makedist('Gamma','a',1,'b',0.5);
y2 = pdf(pd2,xx);
y3 = xx.*exp(-(xx/1800).^2);

% Rayleigh distribution
NN2 = 3e5;
yy4 = 0.3*2*(xx)/NN2.*exp(-xx.^2/NN2);
figure(5)
bar(binranges,bincounts,'histc')
hold on
bar(binranges,bincounts2,'g')
plot(xx, 1e7*yy4, 'c')
plot(xx, 1e7*yy, 'r')
plot(xx, 20*y3, 'g')
% plot(xx, 7*1e7*y2, 'g')
hold off

%%

pd2 = makedist('Gamma','a',10,'b',0.5);
y2 = pdf(pd2,xx/100);
% pd = makedist('Normal','mu',0,'sigma',1);
figure(6)
plot(xx, y2)

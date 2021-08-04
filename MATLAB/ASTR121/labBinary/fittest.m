clear;
figure(1)
clf;

%cflibhelp sin

bin1lambda = [6571,6573,6570,6571,6573,6572,6569];
bin2lambda = [6572,6569,6572,6571,6568,6569,6573];
t = [78.831,79.581,80.742,81.943,82.670,82.982,83.960];

[MA1, IMA1] = max(bin1lambda);
[mi1, Imi1] = min(bin1lambda);
[MA2, IMA2] = max(bin2lambda);
[mi2, Imi2] = min(bin2lambda);

ydev1 = 0.5*(MA1 + mi1);
ydev2 = 0.5*(MA2 + mi2);

tdev1 = 0.5*(t(IMA1)+t(Imi1));
tdev2 = 0.5*(t(IMA2)+t(Imi2));

lam1 = bin1lambda - ydev1;
time1 = t - tdev1;
lamfit1 = fit(time1', lam1', 'sin1');

lam2 = bin2lambda - ydev2;
time2 = t - tdev2;
lamfit2 = fit(time2', lam2', 'sin1');

a1 = lamfit1.a1;
b1 = lamfit1.b1;
c1 = lamfit1.c1;

a2 = lamfit2.a1;
b2 = lamfit2.b1
c2 = lamfit2.c1;

tforsin = linspace(t(1),t(7),300);

yfit1 = a1*sin(b1*(tforsin-tdev1)+c1) + ydev1;
yfit2 = a2*sin(b2*(tforsin-tdev2)+c2) + ydev2;

hold off;
figure(1);
plot(t,bin1lambda,'.r')
hold on
plot(t,bin2lambda,'.b')
ylabel('wavelength (angstroms)')
xlabel('time (days, with arbitrary reference point)')

plot(tforsin, yfit1, 'm');
plot(tforsin, yfit2, 'g');

T1 = ((2*pi)/b1)/365
T2 = ((2*pi)/b2)/365
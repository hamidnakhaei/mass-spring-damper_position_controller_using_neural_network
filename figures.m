xax = 0:0.01:30;
p5 = 5*ones(size(xax));
pax = 5.142*exp(-0.001159*xax)-5.154*exp(-0.4824*xax);
vax =(1553931*exp(-(603*xax)/1250))/625000 - ...
    (13741851269163728853*exp(-(5344944095357343*xax)/4611686018427387904))/2305843009213693952000;
aax = (73449426800395482479100247394517579*exp(-(5344944095357343*xax)/4611686018427387904))...
    /10633823966279326983230456482242756608000 - (937020393*exp(-(603*xax)/1250))/781250000;
y = k*pax+ b*vax+ m*aax;
y= y';
xax = xax';
vax = vax';
aax=aax';
p5 = p5';
figure; hold on;grid on;
a1 = plot(possiotion, 'g', 'LineWidth',2); m1 ='Initialized Controller';
a2 = plot (pax , 'b' ); m2 = 'Optimized Controller';
% a3 = plot (p5, 'red'); m3 ='Desired position';
legend([a1;a2], m1, m2);
title('Optimized Controller vs Initialized Controller')
ylabel('Posotion [m]')
xlabel('Time [microsec]')
hold off
pause;
figure; hold on; grid on;
a1 = plot(velocity, 'g', 'LineWidth',2); m1 ='Initialized Controller';
a2 = plot (vax , 'b' ); m2 = 'Optimized Controller';
legend([a1;a2], m1, m2);
title('Optimized Controller vs Initialized Controller')
ylabel('Velocity [m]')
xlabel('Time [microsec]')
hold off
pause;
figure; hold on; grid on;
a1 = plot(acceleration, 'g', 'LineWidth',2); m1 ='Initialized Controller';
a2 = plot (aax , 'b' ); m2 = 'Optimized Controller';
legend([a1;a2], m1, m2);
title('Optimized Controller vs Initialized Controller')
ylabel('Acceleration [m/s^2]')
xlabel('Time [microsec]')
pause;
figure; hold on; grid on;
a1 = plot(force, 'g', 'LineWidth',2); m1 ='Initialized Controller';
a2 = plot (y , 'b' ); m2 = 'Optimized Controller';
legend([a1;a2], m1, m2);
title('Optimized Controller vs Initialized Controller')
ylabel('Force [N]')
xlabel('Time [microsec]')
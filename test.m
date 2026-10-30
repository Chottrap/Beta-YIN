f0 = 150;
Fs = 22050;
t0 = 0;
tmax = 1;
t = (t0:1/Fs:tmax-1/Fs);
signal = sin(2*pi*f0*t);
N = length(signal);

signal(1 : floor(0.25*N)) = 0;
signal(floor(0.75*N) + 1 : N) = 0;

[t_on,y_on,f_on,t_off,y_off,f_off] = BYIN(signal,'fmin',50);

plot(t,signal)
xline([t_on,t_off])
ylim([-2,2])
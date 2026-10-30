function [time,pitch_time] = YIN(x, Fs, th, fmin, fmax, W_step)
    arguments
        x (1,:) double
        Fs (1,1) double
        th (1,1) double = 0.1;
        fmin (1,1) double = 50;
        fmax (1,1) double = 250;
        W_step (1,1) double = 256
    end
        tic;
    W = floor(Fs/fmin)*2;
    pitch_time = [];
    pitch_time = zeros(1,length(x));
    all_cmndf  = nan(1,length(x));
    for t0 = (W:W_step:length(x))  % W_step to speed up the computation.
        part_x = x(max(round(t0-W/2),1):min(length(x),round(t0+W/2)));
        [cmndf_val,pitch] = getPitch(part_x,Fs,fmin,fmax,th);
        all_cmndf(t0)  = cmndf_val;
        pitch_time(t0) = pitch;
    end
    T_max = floor(Fs/fmin);
    pitch_time = BestLocalEstimate(pitch_time,all_cmndf,T_max,Fs,th);
    time = (0:length(pitch_time)-1)/Fs;
    
    duration = toc;
    fprintf('YIN finished in %.4f',duration);
    fprintf('\n');
end

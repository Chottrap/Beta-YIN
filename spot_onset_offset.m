function [time_on,y_on,freq_on,time_off,y_off,freq_off] = spot_onset_offset(...
       signal, time_YIN ,pitch_along_time, Fs, BetaW, fmin)
    mean_signal = movmean(signal,1000);

    len_YIN = length(time_YIN);
    time_on = nan;
    time_off = nan;
    y_on = nan;
    y_off = nan;
    freq_on = nan;
    freq_off = nan;

    derivative = diff(pitch_along_time);
    cool_derivative = find(diff(derivative~=0));
    for pt_on = cool_derivative
        pitch_range = (pt_on+1:min(pt_on+1+BetaW,length(pitch_along_time)));
        if ~any(pitch_along_time(pitch_range) < fmin)
            time_on = (pt_on-1)/Fs;          
            y_on = mean_signal(pt_on);            
            freq_on = pitch_along_time(pt_on+1);        
            break;
        end
    end

    for pt_off = fliplr(cool_derivative)
        pitch_range = (max(pt_off-BetaW,1):pt_off);
        if ~any(pitch_along_time(pitch_range) < fmin)
            pt_off = pt_off-1;
            time_off = pt_off/Fs;          
            y_off = mean_signal(pt_off);            
            freq_off = pitch_along_time(pt_off+1);        
            break;
        end
    end
end
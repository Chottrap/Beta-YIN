function [t_on,y_on,f_on,t_off,y_off,f_off] = BYIN(signal,varargin)
    
    p  = inputParser;

    %Optional parameters with default values

    addParameter(p, 'Fs', 22050);  % Sampling frequency
    addParameter(p, 'sigma', 0.1); % Default sigma value
    addParameter(p, 'fmin', 50);   % Minimum frequency
    addParameter(p, 'fmax', 1000);   % Maximum frequency, decrease to reduce computation time
    addParameter(p, 'Beta', 5);    % Default beta value
    addParameter(p, 'W_step', 1);  % Step between windows, increase to reduce computation time
    addParameter(p, 'signal_ref',signal) % Usually the pressure
    parse(p, varargin{:}); % Parse input parameters
    
    params = p.Results;

    fields = fieldnames(params);
    for k = 1:numel(fields)
        eval([fields{k} ' = params.' fields{k} ';']);
    end
    W  = floor(Fs / p.Results.fmin);

    continuity_th = Beta*W;
    [time_YIN,freq_YIN] = YIN(signal, Fs, sigma, fmin, fmax, W_step);
    [t_on,y_on,f_on,t_off,y_off,f_off] = spot_onset_offset(...
    signal_ref, time_YIN , freq_YIN, Fs, continuity_th, fmin);
end
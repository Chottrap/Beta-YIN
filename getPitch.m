function [val_cmndf,pitch] = getPitch(x,Fs,fmin,fmax,th)
    
    tau_max = min(floor(Fs/fmin),length(x)-1);

    dfft = difference_function(x,tau_max);

    cmndfft = CMNDF_fft(dfft,tau_max);
    
    tau_min = floor(Fs/fmax);
    [val_cmndf,pitch] = threshold_and_interpol(cmndfft,Fs,th,tau_max,tau_min);
    
    function fftcorr = ACF_fft(x)
        len = length(x);
        nfft = 2^nextpow2(2*len-1);

        fft1 = fft(x,nfft);
        conjug = conj(fft1);
        
        multi = fft1.*conjug;
        r = ifft(multi);
        %# rearrange and keep values corresponding to lags: -(len-1):+(len-1)
        fftcorr = cat(2,r(end-len+2:end),r(1:len));
        fftcorr = fftcorr(len+1:end);
    end

    function df = difference_function(x,tau_max)
            % Inspired by https://github.com/patriceguyot/Yin/blob/289b3618dd8674aad61fa76c5d91be72d763de6b/yin.py#L23
            len = length(x);
            lags = (1:len-1);
            corrective_pent = ((len-1)-abs(lags));
                   
            x_cumsum = cat(2,0,cumsum(x.*x));
            rt = ACF_fft(x);
            rt = rt./corrective_pent;

            df = (fliplr(x_cumsum(2:len)) + x_cumsum(len+1) - x_cumsum(2:len))./corrective_pent - 2 * rt;
            df = df(1:tau_max);
        end
      
    function cum_diff = CMNDF_fft(df,N)
        cum_diff = df(2:end) .* (2:N) ./ cumsum(df(2:end));
        cum_diff = [1 cum_diff];
    end

        
    function [val_cmndf,pitch] = threshold_and_interpol(cmndf,Fs,th,tau_max,tau_min)     
            tau = tau_min;
            if any(cmndf(tau_min:tau_max)<th)
                while (((cmndf(tau)>th) | (cmndf(tau+1)<cmndf(tau))) & (tau<tau_max-1))
                    tau = tau+1;
                end
                val_cmndf = cmndf(tau);
                pitch = Fs/tau;
            else
                [val_cmndf,~] = min(cmndf);
                pitch = 0;
            end
        end
end
   
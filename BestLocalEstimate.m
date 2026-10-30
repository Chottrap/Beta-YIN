function pitch_along_time = BestLocalEstimate(pitch_along_time,all_cmndf,T_max,Fs,th)
    len = length(all_cmndf);
    pitch_along_time_copy = pitch_along_time;
    % for t = [1:len]
    %     if all_cmndf(t)>th
    %         all_cmndf(t) = 0;
    %     end
    % end
    all_cmndf(all_cmndf > th) = Inf;
    for t = [1:len]
        theta_range = [max(1,t-floor(T_max/4)):min(t+floor(T_max/4),len)];
        %theta_range = [max(1,t-floor(T_max/2)):min(t+floor(T_max/2),len)];
        % theta_range = [max(1,t-floor(T_max)):min(t+floor(T_max),len)];
        [min_cmndf,argmin_cmndf] = min(all_cmndf(theta_range));
        pitch_along_time(t) = pitch_along_time_copy(theta_range(argmin_cmndf));
    end
end
           

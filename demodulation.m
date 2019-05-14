function llr = demodulation(y, constellation, m, M, demod_indices, sigma, N)
%This function is much faster than the system-function 'qamdemod(y, M, 'OutputType', 'llr', NoiseVariance', sigma^2)'.
if isempty(constellation)%BPSK
    llr = 2/sigma^2*y;
else%NOT BPSK
    p0 = zeros(N, 1);
    p1 = zeros(N, 1);
    for i_y = 1 : length(y)
        index_y = m * (i_y - 1);
        p_ylx = exp(-abs(y(i_y) - constellation).^2/2/sigma^2);%We omit the const term '1/2/pi/sigma^2', since we only need p0/p1.
        sum_p_ylx = sum(p_ylx);
        for i_m = 1 : m
            index_m = M/2 * (i_m - 1);
            for i_c = 1 : M/2
                p1(index_y + i_m) = p1(index_y + i_m) + p_ylx(demod_indices(index_m + i_c));
            end
            p0(index_y + i_m) = sum_p_ylx - p1(index_y + i_m);
        end
    end
    llr = log(p0./p1);
end
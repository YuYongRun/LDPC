% clear
dv = 3;
dc = 6;
sqrt_dc_1 = sqrt(dc - 1);
AWGN_sigma = 0.1;
AWGN_sigma_inc = 0.1;
dI = 1e-5;
while(AWGN_sigma_inc >= 1e-5)
    stop = 0;
    while(1)
        variance_channel_LLR = 4/AWGN_sigma/AWGN_sigma;
        disp(['AWGN-Sigma = ' num2str(AWGN_sigma)])
        for i = 1 : floor(1/dI - 1)
            I_AV = i * dI;
            I_EV = J(sqrt((dv - 1) * Jinv(I_AV)^2 + variance_channel_LLR));
            I_EC = 1 - J( sqrt_dc_1 * Jinv(1 - I_EV));
            if abs(I_AV - I_EC) < dI
                stop = 1;
                break;
            end
        end
        if stop 
            break
        end
        AWGN_sigma = AWGN_sigma + AWGN_sigma_inc;
    end
    AWGN_sigma = AWGN_sigma - AWGN_sigma_inc;
    AWGN_sigma_inc = AWGN_sigma_inc/10;
    AWGN_sigma = AWGN_sigma + AWGN_sigma_inc;
end
disp(['EXIT CHART shows that the Iterative Decoding Threshold = ' num2str(AWGN_sigma - AWGN_sigma_inc)])
    
    

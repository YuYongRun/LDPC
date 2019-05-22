clear
format long

%max dv = 6;
% vn_degree = [1 2 3 5]; %dv - 1
% vn_edge_portion = [0.332 0.247 0.110 0.311];
% cn_degree = [5 6]; %dc - 1
% cn_edge_portion = [0.766 0.234];

%max dv = 10;
% vn_degree = [1 2 3 9]; %dv - 1
% vn_edge_portion = [0.267 0.176 0.127 0.43];
% cn_degree = [4 7]; %dc - 1
% cn_edge_portion = [0.113 0.887];

vn_degree = [1 2]; %dv - 1
vn_edge_portion = [4/7 3/7];
cn_degree = [2 3]; %dc - 1
cn_edge_portion = [3/7 4/7];

% max dv = 11;
% vn_degree = [1 2 3 10]; %dv - 1
% vn_edge_portion = [0.239 0.295 0.033 0.433];
% cn_degree = [6 7]; %dc - 1
% cn_edge_portion = [0.43 0.57];

%max dv = 30
% vn_degree = [1 2 5 6 7 8 9 27 29]; %dv - 1
% vn_edge_portion = [0.196 0.24 0.002 0.055 0.166 0.041 0.011 0.002 0.287];
% cn_degree = [7 8 9]; %dc - 1
% cn_edge_portion = [0.007 0.991 0.002];

AWGN_sigma = 0.1;%a very high SNR
AWGN_sigma_inc = 0.1;%increamental value, not const. It will decrease with the proceeding of this program. 
dI = 1e-5;
while(AWGN_sigma_inc >= 1e-5)
    stop = 0;
    while(1)
        variance_channel_LLR = 4/AWGN_sigma^2;
        disp(['AWGN-Sigma = ' num2str(AWGN_sigma)])
        for i = 1 : floor(1/dI - 1)
            I_AV = i * dI;
            I_EV = 0;
            for k = 1 : length(vn_degree)
                I_EV = I_EV + vn_edge_portion(k) * J(sqrt( vn_degree(k) * Jinv(I_AV)^2 + variance_channel_LLR ));
            end
            I_EC = 0;
            for k = 1 : length(cn_degree)
                I_EC = I_EC + cn_edge_portion(k) * (1 - J( sqrt(cn_degree(k)) * Jinv(1 - I_EV)) );
            end
            if abs(I_AV - I_EC) < 1e-6%we think now I_AV = I_EC
                stop = 1;
                break
            end
        end
        if stop
            break
        end
        AWGN_sigma = AWGN_sigma + AWGN_sigma_inc;
    end
    AWGN_sigma = AWGN_sigma - AWGN_sigma_inc;%the previous sigma is too large.
    AWGN_sigma_inc = AWGN_sigma_inc/10;%refined incremental value
    AWGN_sigma = AWGN_sigma + AWGN_sigma_inc;%a new sigma.
end
disp(['EXIT CHART shows that the Iterative Decoding Threshold = ' num2str(AWGN_sigma - AWGN_sigma_inc)])


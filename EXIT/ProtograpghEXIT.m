%Protograph EXIT, namely Multi-dimension-EXIT, is just another form of the SPA decoding.

% Several ProtoGraph matrices are provided below. 
%They are selected from textbooks or existing literatures. 

%W. E. Ryan, S. Lin, channel codes classical and modern, section 9.6.3
% B = [2 1 1; 
%      1 1 1];
% puncture_index = [];

%W. E. Ryan, S. Lin, channel codes classical and modern, section 9.6.3
B = [2 0 2;
     1 2 0];
puncture_index = [];

%W. E. Ryan, S. Lin, channel codes classical and modern, section 9.6.3
% B = [1 2 1 1 0;
%      2 1 1 1 0;
%      1 2 0 0 1]; 
% puncture_index = 2;

%W. E. Ryan, S. Lin, channel codes classical and modern, section 9.6.3
% B = [1 3 0 0;
%      0 1 2 1;
%      0 2 0 1;];
%  puncture_index = 2;

%Rate 1/8 AR3A
% B = [1 2 0 0 0 0 0 0 0;
%      0 1 1 1 0 0 0 0 0;
%      0 1 0 1 0 0 0 1 0;
%      0 3 0 0 1 0 0 0 0;
%      0 3 0 0 0 1 0 0 0;
%      0 3 0 0 0 0 1 0 0;
%      0 1 1 0 0 0 0 1 0;
%      0 3 0 0 0 0 0 0 1];
% puncture_index = 2;

%Rate 1/6 AR3A
% B = [1 2 0 0 0 0 0;
%      0 1 1 1 0 0 0;
%      0 1 0 1 0 0 1;
%      0 3 0 0 1 0 0;
%      0 3 0 0 0 1 0;
%      0 1 1 0 0 0 1;];
%  puncture_index = 2;

%Low-rate LDPC codes with simple protograph structure, IEEE xPLORE
%Fig6, left.
% B = [1 3 1 0 0;
%     2 1 1 1 0;
%     1 1 0 1 1;];
% puncture_index = 2;

M = size(B, 1);
N = size(B, 2);
R = (N - M)/(N - length(puncture_index)); 
[B_CN_absolute, B_CN_relative, B_VN_absolute, vn_degree, cn_degree]  = extract_B_structure(B);

AWGN_sigma = 0.1;
AWGN_sigma_inc = 0.1;
VN_tmp = zeros(max(vn_degree), 1);
CN_tmp = zeros(max(cn_degree), 1);
I_CMI = zeros(N, 1);

max_iter = 1e3;
while(AWGN_sigma_inc >= 1e-4)
    while(1)
        convergence = 0;
        channel_LLR_variance = 4/AWGN_sigma^2 * ones(N, 1);
        channel_LLR_variance(puncture_index) = 0;
        mutual_info_matrix = zeros(max(vn_degree), N);
        for iter = 1 : max_iter
            %VN Update
            for j = 1 : N
                for i = 1 : vn_degree(j)
                    tmp = 0;
                    for k = 1 : i - 1
                        tmp = tmp + B(B_VN_absolute(k, j), j) * Jinv(mutual_info_matrix(k, j))^2;
                    end
                    tmp = tmp + (B(B_VN_absolute(i, j), j) - 1) * Jinv(mutual_info_matrix(i, j))^2;
                    for k = i + 1 : vn_degree(j)
                        tmp = tmp + B(B_VN_absolute(k, j), j) * Jinv(mutual_info_matrix(k, j))^2;
                    end
                    VN_tmp(i) = J(sqrt(tmp + channel_LLR_variance(j)));
                end
                for i = 1 : vn_degree(j)
                    mutual_info_matrix(i, j) = VN_tmp(i);
                end
            end
            %CN Update
            for i = 1 : M
                for j = 1 : cn_degree(i)
                    CN_tmp(j) = Jinv(1 - mutual_info_matrix(B_CN_relative(i, j), B_CN_absolute(i, j)))^2;
                end
                for j = 1 : cn_degree(i)
                    tmp = 0;
                    for k = 1 : j - 1
                        tmp = tmp + B(i, B_CN_absolute(i, k)) * CN_tmp(k);
                    end
                    tmp = tmp + (B(i, B_CN_absolute(i, j)) - 1) * CN_tmp(j);
                    for k = j + 1 : cn_degree(i)
                        tmp = tmp + B(i, B_CN_absolute(i, k)) * CN_tmp(k);
                    end
                    mutual_info_matrix(B_CN_relative(i, j), B_CN_absolute(i, j)) = 1 - J(sqrt(tmp));
                end
            end
            %Decision
            for j = 1 : N
                tmp = channel_LLR_variance(j);
                for i = 1 : vn_degree(j)
                    tmp = tmp + B(B_VN_absolute(i, j), j) * Jinv(mutual_info_matrix(i, j))^2;
                end
                I_CMI(j) = J(sqrt(tmp));
            end         
            max_delta = max(abs(1 - I_CMI));
            if max_delta < 1e-6
                convergence = 1;
                break;
            end
        end
        if convergence
            AWGN_sigma = AWGN_sigma + AWGN_sigma_inc;
            disp(['AWGN-Sigma = ' num2str(AWGN_sigma)])
        else
            AWGN_sigma = AWGN_sigma - AWGN_sigma_inc;
            AWGN_sigma_inc = AWGN_sigma_inc/10;
            AWGN_sigma = AWGN_sigma + AWGN_sigma_inc;
            disp(['AWGN-Sigma = ' num2str(AWGN_sigma)])
            break;
        end
    end
end
EnsembleDecodingThreshold = AWGN_sigma - AWGN_sigma_inc;
disp(['Protograph EXIT shows that the threshold is AWGN-Sigma = ' num2str(EnsembleDecodingThreshold) '¡û¡ú Eb/N0 = ' num2str(10 * log10(1/2/R/EnsembleDecodingThreshold^2)) 'dB.'])
clear
max_iter = 1e3;
%dv = 6;
vn_degree = [1 2 3 5]; %dv - 1
vn_edge_portion = [0.332 0.247 0.110 0.311];
cn_degree = [5 6]; %dc - 1
cn_edge_portion = [0.766 0.234];

%dv = 11;
% vn_degree = [1 2 3 10]; %dv - 1
% vn_edge_portion = [0.239 0.295 0.033 0.433];
% cn_degree = [6 7]; %dc - 1
% cn_edge_portion = [0.43 0.57];

%dv = 30
% vn_degree = [1 2 5 6 7 8 9 27 29]; %dv - 1
% vn_edge_portion = [0.196 0.24 0.002 0.055 0.166 0.041 0.011 0.002 0.287];
% cn_degree = [7 8 9]; %dc - 1
% cn_edge_portion = [0.007 0.991 0.002];

Ecn = zeros(length(cn_degree), 1);
Evn = zeros(length(vn_degree), 1);
sigma = 0.75;
sigma_inc = 1e-3;
Pe = 1e-5;
iter = 1;
while(iter <= max_iter)
    if iter == 1
        for k = 1 : length(cn_degree)
            [Ecn(k), ~] = phi_inverse(1 - (1 - phi(2/sigma^2))^cn_degree(k));
        end
        Ave_CN = cn_edge_portion * Ecn;
        Evn = (2/sigma^2 + vn_degree * Ave_CN)';
        current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));
        if current_Pe < Pe
            sigma = sigma + sigma_inc;
            iter = 1;
        else
            iter = iter + 1;
        end
    else
        weighted_sum = 0;
        for k = 1 : length(vn_degree)
            weighted_sum = weighted_sum + vn_edge_portion(k) * phi(Evn(k));
        end
        tmp = 1 - weighted_sum; 
        for k = 1 : length(cn_degree)
            [Ecn(k), ~] = phi_inverse(1 - tmp^cn_degree(k));
        end
        Ave_CN = cn_edge_portion * Ecn;
        Evn = (2/sigma^2 + vn_degree * Ave_CN)';
        current_Pe = vn_edge_portion * (1 - normcdf(sqrt(Evn/2)));
        if current_Pe < Pe
            sigma = sigma + sigma_inc;
            iter = 1;
        else
            iter = iter + 1;
        end
    end
    if iter > max_iter
        disp(['Gaussian Approximation is finished. The threshold sigma = ' num2str(sigma - sigma_inc)]);
    end
end
        
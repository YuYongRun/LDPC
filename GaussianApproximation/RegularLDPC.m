max_iter = 1e3;
dc = 4;
dv = 3;
sigma = 0.75;
sigma_inc = 1e-4;
Pe = 1e-6;
iter = 1;
while(iter <= max_iter)
    if iter == 1
        [u_cn, ~] = phi_inverse(1 - (1 - phi(2/sigma^2))^(dc - 1));
        u_vn = 2/sigma^2 + (dv - 1) * u_cn;
        current_Pe = 1 - normcdf(sqrt(u_vn/2));
        if current_Pe < Pe
            sigma = sigma + sigma_inc;
            iter = 1;
        else
            iter = iter + 1;
        end
    else
        [u_cn, ~] = phi_inverse(1 - (1 - phi(u_vn))^(dc - 1));
        u_vn = (dv - 1) * u_cn + 2/sigma^2;
        current_Pe = 1 - normcdf(sqrt(u_vn/2));
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
        
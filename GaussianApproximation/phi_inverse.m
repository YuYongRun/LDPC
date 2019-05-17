function [x, num_iter] = phi_inverse(y)
if (y <= 1.0221) && (y >= 0.0388)
    x = ((0.0218 - log(y))/0.4527)^(1/0.86);
    num_iter = 0;
else
    %Using Newton descending method to get phi^{-1}(x)
    x0 = 0.0388;
    x1 = x0 - (phi(x0) - y)/derivative_phi(x0);
    delta = abs(x1 - x0);
    epsilon = 1e-3;
    num_iter = 0;
    while(delta >= epsilon)
        num_iter = num_iter + 1;
        x0 = x1;
        x1 = x1 - (phi(x1) - y)/derivative_phi(x1);
        %当x1过大，放宽epsilon
        if x1 > 1e1
            epsilon = 0.1;
        end       
        delta = abs(x1 - x0);
    end
    x = x1;
end
end

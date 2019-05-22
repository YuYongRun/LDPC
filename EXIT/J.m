function y = J(sigma)
%Approximation From 'Design of Low-Density Parity-Check Codes for Modulation and Detection', from IEEE Xplore.
if sigma <= 1.6363 && sigma >= 0
    y = -0.0421061 * sigma.^3 + 0.209252 * sigma.^2 - 0.00640081 * sigma;
else
    if sigma <= 10
        y = 1 - exp(0.00181491 * sigma.^3 - 0.142675 * sigma.^2 - 0.0822054 * sigma + 0.0549608);
    else
        y = 1;
    end
end
if y < 0%if inappropriate approximation occurs, use exact calculation.
    fun = @(sigma, x) exp(-(x - sigma^2/2).^2/2/sigma^2) .* log2(1 + exp(-x));
    y = 1 - 1/sqrt(2 * pi)/sigma * integral(@(x) fun(sigma, x), -inf, inf);%(-Inf, +Inf) is safe because there are e^{-x} and e^{-x^2}, while sigma is finite.
end
end
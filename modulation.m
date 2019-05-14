function s = modulation(constellation, m, rho_inv, x, base_vec, N)
%Fast modulation.
if isempty(constellation)
        s = 1 - 2 * x;%BPSK
else
    %Not BPSK
    numbers = x .* base_vec;
    s = constellation(rho_inv(1 + sum(reshape(numbers, m, N/m))));
end
        
        
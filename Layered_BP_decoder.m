function [x_hat, iter_this_time] = Layered_BP_decoder(llr, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, vn_degree, cn_degree, max_iter)
VN_array = zeros(max(vn_degree), N);
CN_tanh_tmp = zeros(max(cn_degree), 1);%CN temporary memory.
iter_this_time = max_iter;
for t = 1 : max_iter
    for c = 1 : M
        product = 1;
        for c_neighbor = 1 : cn_degree(c)%read data from VNs, and then store in CNs memory.
            Lji = sum(VN_array(:, H_row_one_absolute_index(c, c_neighbor))) + llr(H_row_one_absolute_index(c, c_neighbor)) - VN_array(H_comlumn_one_relative_index(c, c_neighbor), H_row_one_absolute_index(c, c_neighbor));%VN update. However, this simple MATLAB sentence consumes a lot of time.
            CN_tanh_tmp(c_neighbor) = 1 - 2/(1 + exp(Lji));%Exact decoding. Equivalent to tanh(x/2), usually faster.
            product = product * CN_tanh_tmp(c_neighbor);%Avoid repeated calculations.
        end
        for c_neighbor = 1 : cn_degree(c)
            Lij = product/CN_tanh_tmp(c_neighbor);%Extract Extrinsic information, i.e., divide itself.
            Lij = sign(Lij) * min(abs(Lij), 1 - 1e-15);
            VN_array(H_comlumn_one_relative_index(c, c_neighbor), H_row_one_absolute_index(c, c_neighbor)) = log((1 + Lij)/(1 - Lij));%Exact decoding, equivalent to 2atanh(x), much faster. 
        end
    end
    x_hat = (sum(VN_array)' + llr) < 0;%Belief propagation Decision.
    parity_check = zeros(M, 1);
    for m = 1 : M
        for k = 1 : 1 : cn_degree(m)
            parity_check(m) = parity_check(m) + x_hat(H_row_one_absolute_index(m, k));
        end
    end
    if ~sum(mod(parity_check, 2))%early stop, to see whether Hx = 0.
        iter_this_time = t;
        break;
    end
end
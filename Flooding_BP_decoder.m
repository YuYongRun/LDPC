function [x_hat, iter_this_time] = Flooding_BP_decoder(llr, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, vn_degree, cn_degree, max_iter)
VN_array = zeros(max(vn_degree), N);
CN_tanh_tmp = zeros(max(cn_degree), 1);%CN temporary memory.
iter_this_time = max_iter;
for t = 1 : max_iter
    sum_VN = sum(VN_array);%VN update
    for v = 1 : N
        for v_neighbor = 1 : vn_degree(v)
            VN_array(v_neighbor, v) = sum_VN(v) - VN_array(v_neighbor, v) + llr(v);%Belief Propagation Rule. The initial 2/sigma^2*y is automatically incorporateed here.
        end
    end
    for c = 1 : M%CN update
        product = 1;
        for c_neighbor = 1 : cn_degree(c)%read data from VNs, and then store in CNs memory.
            CN_tanh_tmp(c_neighbor) = 1 - 2/(1 + exp(VN_array(H_comlumn_one_relative_index(c, c_neighbor), H_row_one_absolute_index(c, c_neighbor))));%Exact decoding.
            product = product * CN_tanh_tmp(c_neighbor);
        end
        for c_neighbor = 1 : cn_degree(c)
            x = product/CN_tanh_tmp(c_neighbor);
            x = sign(x) * min(abs(x), 1 - 1e-15);%Numerical Stability.
            VN_array(H_comlumn_one_relative_index(c, c_neighbor), H_row_one_absolute_index(c, c_neighbor)) = log((1 + x)/(1 - x));%Exact decoding.
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
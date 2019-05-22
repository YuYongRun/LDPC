function [num_block_err, num_bit_err, num_iter, num_runs] = simulation(ebno_vec, conste_name, P, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, K, vn_degree,...
cn_degree, vn_distribution, cn_distribution, max_iter, max_runs, resolution, max_err)
R = K/N;
num_runs = zeros(length(ebno_vec), 1);
num_block_err = zeros(length(ebno_vec), 1);
num_bit_err = zeros(length(ebno_vec), 1);
num_iter = zeros(length(ebno_vec), 1);
[constellation, rho_inv, base_vec, demod_indices, is2D, m, num_conste_points] = get_constellation(conste_name, N);
tic
% profile on
for i_run = 1 : max_runs
    if  mod(i_run, max_runs/resolution) == 1
        disp(' ')
        disp([conste_name ' Simualtion Running = ' num2str(i_run)])
        disp(['N = ' num2str(N) ', K = ' num2str(K) ', Max Iteration Number = ' num2str(max_iter) '. ' 'H density = ' num2str(100 * sum(vn_degree)/M/N) '%.']);
        disp(' ');
        disp('VN Degree Distribution: ');
        disp(vn_distribution);
        disp(' ');
        disp('CN Degree Distribution: ');
        disp(cn_distribution);
        disp(' ');
        disp('current BLER');
        disp(num2str([ebno_vec' num_block_err./num_runs]));
        disp('current BER');
        disp(num2str([ebno_vec' num_bit_err./num_runs/K]));
        disp('Average Iteration Numbers')
        disp(num2str([ebno_vec' num_iter./num_runs]));
    end    
    u = round(rand(K, 1));
    parity_check_bits = mod(P * u, 2);
    x = [u; parity_check_bits];
    symbol = modulation(constellation, m, rho_inv, x, base_vec, N);
    n = randn(N/m, 1) + randn(N/m, 1) * 1j * is2D;
    for i_ebno = 1 : length(ebno_vec)
        if num_block_err(i_ebno) >= max_err
            continue;
        end
        num_runs(i_ebno) = num_runs(i_ebno) + 1;
        sigma = 1/sqrt(2 * R * m) * 10^(-ebno_vec(i_ebno)/20);
        y = symbol + sigma * n;
        llr = demodulation(y, constellation, m, num_conste_points, demod_indices, sigma, N);
%         [x_hat, iter_this_time] = Layered_BP_decoder(llr, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, vn_degree, cn_degree, max_iter);
        [x_hat, iter_this_time] = Flooding_BP_decoder(llr, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, vn_degree, cn_degree, max_iter);
        num_iter(i_ebno) = num_iter(i_ebno) + iter_this_time;
        if any(x_hat ~= x)
            num_block_err(i_ebno) = num_block_err(i_ebno) + 1;
            num_bit_err(i_ebno) = num_bit_err(i_ebno) + sum(u ~= x_hat(1 : K));
        end
    end
    if all(num_block_err == max_err)
        break;
    end
end
% profile viewer
toc
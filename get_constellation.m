function [constellation, rho_inv, base_vec, demod_indices, is2D, m, M] = get_constellation(name, N)
%This is a very carefully designed High-order Modultion MATLAB program.

%You may see many 'strange' operations below. Such operations are needed to obtain a
%very fast MATLAB codes that has similar speed to C language.
switch name
    case 'BPSK'
        constellation = [];
        demod_indices = [];
        base_vec = [];
        rho_inv = [];%Avoid using 'if' or 'switch' to find the target constellation point. We use 'rho_inv' to directly locate the target constellation point.
        is2D = 0;% 2 dimensions ¡ú 1; otherwise 0.
        m = 1;%how many bits per symbol.
        M = 2^m;
    case 'QPSK'
        constellation = [-1/sqrt(2) + 1j * 1/sqrt(2); -1/sqrt(2) - 1j * 1/sqrt(2); 1/sqrt(2) + 1j * 1/sqrt(2); 1/sqrt(2) - 1j * 1/sqrt(2);];
        bit_label = [0 1; 1 1; 0 0; 1 0];
        base = [2; 1];
        rho = bit_label * base + 1;
        rho_inv(rho) = 1 : 4;
        is2D = 1;
        m = 2;
        base_vec = zeros(N, 1);
        base_vec(1 : m : N) = 2;
        base_vec(2 : m : N) = 1;
        M = 2^m;
        demod_indices = zeros(M/2, m);
        for i_m = 1 : m
            cnt_1 = 1;
            for k = 1 : M
                if bit_label(k, i_m)
                    demod_indices(cnt_1, i_m) = k;
                    cnt_1 = cnt_1 + 1;
                end
            end
        end
        demod_indices = demod_indices(:);
    case '16QAM'
        constellation = 1/sqrt(10) * [-3 + 3j; -1 + 3j; 1 + 3j; 3 + 3j;
            -3 + 1j; -1 + 1j; 1 + 1j; 3 + 1j;
            -3 - 1j; -1 - 1j; 1 - 1j; 3 - 1j;
            -3 - 3j; -1 - 3j; 1 - 3j; 3 - 3j;];
        bit_label = [1 1 1 0; 1 0 1 0; 0 0 1 0; 0 1 1 0; 1 1 1 1; 1 0 1 1; 0 0 1 1; 0 1 1 1; 1 1 0 1; 1 0 0 1; 0 0 0 1; 0 1 0 1; 1 1 0 0; 1 0 0 0; 0 0 0 0; 0 1 0 0];
        base = [8; 4; 2; 1];
        rho = bit_label * base + 1;
        rho_inv(rho) = 1 : 16;
        is2D = 1;
        m = 4;
        base_vec = zeros(N, 1);
        base_vec(1 : m : N) = 8;
        base_vec(2 : m : N) = 4;
        base_vec(3 : m : N) = 2;
        base_vec(4 : m : N) = 1;
        M = 2^m;
        demod_indices = zeros(M/2, m);
        for i_m = 1 : m
            cnt_1 = 1;
            for k = 1 : M
                if bit_label(k, i_m)
                    demod_indices(cnt_1, i_m) = k;
                    cnt_1 = cnt_1 + 1;
                end
            end
        end
        demod_indices = demod_indices(:);
    case '64QAM'
        constellation = zeros(64, 1);
        cnt = 1;
        for x_axis = -7 : 2 : 7
            for y_axis = 7 : -2  : -7
                constellation(cnt) = x_axis + 1j * y_axis;
                cnt = cnt + 1;
            end
        end
        constellation = constellation(:)/sqrt(42);
        bit_label = ...
            [1 0 1 1 1 1;
            1 0 1 1 1 0;
            1 0 1 0 1 0;
            1 0 1 0 1 1;
            1 1 1 0 1 1;
            1 1 1 0 1 0;
            1 1 1 1 1 0;
            1 1 1 1 1 1;
            1 0 1 1 0 1;
            1 0 1 1 0 0;
            1 0 1 0 0 0;
            1 0 1 0 0 1;
            1 1 1 0 0 1;
            1 1 1 0 0 0;
            1 1 1 1 0 0;
            1 1 1 1 0 1;
            1 0 0 1 0 1;
            1 0 0 1 0 0;
            1 0 0 0 0 0;
            1 0 0 0 0 1;
            1 1 0 0 0 1;
            1 1 0 0 0 0;
            1 1 0 1 0 0;
            1 1 0 1 0 1;
            1 0 0 1 1 1;
            1 0 0 1 1 0;
            1 0 0 0 1 0;
            1 0 0 0 1 1;
            1 1 0 0 1 1;
            1 1 0 0 1 0;
            1 1 0 1 1 0;
            1 1 0 1 1 1;
            0 0 0 1 1 1;
            0 0 0 1 1 0;
            0 0 0 0 1 0;
            0 0 0 0 1 1;
            0 1 0 0 1 1;
            0 1 0 0 1 0;
            0 1 0 1 1 0;
            0 1 0 1 1 1;
            0 0 0 1 0 1;
            0 0 0 1 0 0;
            0 0 0 0 0 0;
            0 0 0 0 0 1;
            0 1 0 0 0 1;
            0 1 0 0 0 0;
            0 1 0 1 0 0;
            0 1 0 1 0 1;
            0 0 1 1 0 1;
            0 0 1 1 0 0;
            0 0 1 0 0 0;
            0 0 1 0 0 1;
            0 1 1 0 0 1;
            0 1 1 0 0 0;
            0 1 1 1 0 0;
            0 1 1 1 0 1;
            0 0 1 1 1 1;
            0 0 1 1 1 0;
            0 0 1 0 1 0;
            0 0 1 0 1 1;
            0 1 1 0 1 1;
            0 1 1 0 1 0;
            0 1 1 1 1 0;
            0 1 1 1 1 1;];
        base = [32; 16; 8; 4; 2; 1];
        rho = bit_label * base + 1;
        rho_inv(rho) = 1 : 64;
        is2D = 1;
        m = 6;
        base_vec = zeros(N, 1);
        base_vec(1 : m : N) = 32;
        base_vec(2 : m : N) = 16;
        base_vec(3 : m : N) = 8;
        base_vec(4 : m : N) = 4;
        base_vec(5 : m : N) = 2;
        base_vec(6 : m : N) = 1;
        M = 2^m;
        demod_indices = zeros(M/2, m);
        for i_m = 1 : m
            cnt_1 = 1;
            for k = 1 : M
                if bit_label(k, i_m)
                    demod_indices(cnt_1, i_m) = k;
                    cnt_1 = cnt_1 + 1;
                end
            end
        end
        demod_indices = demod_indices(:);
    case '4ASK'
        constellation = (-3 : 2 : 3)'/sqrt(5);
        bit_label = [0 0; 0 1; 1 1; 1 0];
        base = [2; 1];
        rho = bit_label * base + 1;
        rho_inv(rho) = 1 : 4;
        is2D = 0;
        m = 2;
        base_vec = zeros(N, 1);
        base_vec(1 : m : N) = 2;
        base_vec(2 : m : N) = 1;
        M = 2^m;
        demod_indices = zeros(M/2, m);
        for i_m = 1 : m
            cnt_1 = 1;
            for k = 1 : M
                if bit_label(k, i_m)
                    demod_indices(cnt_1, i_m) = k;
                    cnt_1 = cnt_1 + 1;
                end
            end
        end
        demod_indices = demod_indices(:);
    case '8ASK'
        constellation = (-7 : 2 : 7)'/sqrt(21);
        bit_label = [0 0 0; 0 0 1; 0 1 1; 0 1 0; 1 1 0; 1 1 1; 1 0 1; 1 0 0];
        base = [4; 2; 1];
        rho = bit_label * base + 1;
        rho_inv(rho) = 1 : 8;
        is2D = 0;
        m = 3;
        base_vec = zeros(N, 1);
        base_vec(1 : m : N) = 4;
        base_vec(2 : m : N) = 2;
        base_vec(3 : m : N) = 1;
        M = 2^m;
        demod_indices = zeros(M/2, m);
        for i_m = 1 : m
            cnt_1 = 1;
            for k = 1 : M
                if bit_label(k, i_m)
                    demod_indices(cnt_1, i_m) = k;
                    cnt_1 = cnt_1 + 1;
                end
            end
        end
        demod_indices = demod_indices(:);
    case '16ASK'
        constellation = (-15 : 2 : 15)'/sqrt(85);
        bit_label = [0 0 0 0; 0 0 0 1; 0 0 1 1; 0 0 1 0; 0 1 1 0; 0 1 1 1; 0 1 0 1; 0 1 0 0; 1 1 0 0; 1 1 0 1; 1 1 1 1; 1 1 1 0; 1 0 1 0; 1 0 1 1; 1 0 0 1; 1 0 0 0];
        base = [8; 4; 2; 1];
        rho = bit_label * base + 1;
        rho_inv(rho) = 1 : 16;
        is2D = 0;
        m = 4;
        base_vec = zeros(N, 1);
        base_vec(1 : m : N) = 8;
        base_vec(2 : m : N) = 4;
        base_vec(3 : m : N) = 2;
        base_vec(4 : m : N) = 1;
        M = 2^m;
        demod_indices = zeros(M/2, m);
        for i_m = 1 : m
            cnt_1 = 1;
            for k = 1 : M
                if bit_label(k, i_m)
                    demod_indices(cnt_1, i_m) = k;
                    cnt_1 = cnt_1 + 1;
                end
            end
        end
        demod_indices = demod_indices(:);
    case '256QAM'
        m = 8;
        M = 2^m;
        constellation = zeros(64, 1);
        cnt = 1;
        for x_axis = -15 : 2 : 15
            for y_axis = 15 : -2  : -15
                constellation(cnt) = x_axis + 1j * y_axis;
                cnt = cnt + 1;
            end
        end
        constellation = constellation(:)/sqrt(sum(abs(constellation).^2)/M);
        ask8 = [0 0 0 0; 0 0 0 1; 0 0 1 1; 0 0 1 0; 0 1 1 0; 0 1 1 1; 0 1 0 1; 0 1 0 0; 1 1 0 0; 1 1 0 1; 1 1 1 1; 1 1 1 0; 1 0 1 0; 1 0 1 1; 1 0 0 1; 1 0 0 0];
        bit_label = zeros(M, m);
        for i = 1 : sqrt(M)
            index = sqrt(M) * (i - 1);
            for j = 1 : sqrt(M)
                bit_label(index + j, 1 : 4) = ask8(i, :);
                bit_label(index + j, 5 : 8) = ask8(j, :);
            end
        end
        base = [128; 64; 32; 16; 8; 4; 2; 1];
        rho = bit_label * base + 1;
        rho_inv(rho) = 1 : M;
        is2D = 1;
        base_vec = zeros(N, 1);
        base_vec(1 : m : N) = 128;
        base_vec(2 : m : N) = 64;
        base_vec(3 : m : N) = 32;
        base_vec(4 : m : N) = 16;
        base_vec(5 : m : N) = 8;
        base_vec(6 : m : N) = 4;
        base_vec(7 : m : N) = 2;
        base_vec(8 : m : N) = 1;
        demod_indices = zeros(M/2, m);
        for i_m = 1 : m
            cnt_1 = 1;
            for k = 1 : M
                if bit_label(k, i_m)
                    demod_indices(cnt_1, i_m) = k;
                    cnt_1 = cnt_1 + 1;
                end
            end
        end
        demod_indices = demod_indices(:);
end
end

clear
addpath('Mackey_codes');
addpath('IEEE80211n');
addpath('IEEE80216e');
addpath('load_H_matrix');
addpath('FiniteGeometry');
addpath('ProgressiveEdgeGrowth');
addpath('Count-6-cycles');
addpath('Count-8-cycles');
addpath('Count-10-cycles');
% H = N999M111();
% H = N1998M222();
% H = N273M82();
% H = N96M48();
% H = N504M252();
% H = N1008M504();
% H = N1057M244();
% H = N2048M1030();
% H = N16383M2131();
% H = EG255();
% H = EG1023();
% H = EG4095();
% H = PG273();
% H = PG1057();
H = IEEE80211n(648, 1/2);%N takes values in {648, 1296, 1944}. R takes values in {1/2, 2/3, 3/4, 5/6}.
% H = IEEE80216e(2304, '1/2');
%N is an integer.
%N takes values in {576   672   768   864   960  1056  1152  1248  1344
%1440  1536  1632  1728  1824  1920  2016  2112  2208  2304}.
%R is a string.
%R takes values in {'1/2', '2/3A', '2/3B', '3/4A', '3/4B',
%'5/6'}.
[M, N, K, vn_degree, cn_degree, P, H_row_one_absolute_index, H_comlumn_one_relative_index, vn_distribution, cn_distribution] = H_matrix_process(H);
num_6_cycles = count_6_cycles(H_row_one_absolute_index, cn_degree);
% num_8_cycles = count_8_cycles(H_row_one_absolute_index, cn_degree);
% num_10_cycles = count_10_cycles(H_row_one_absolute_index, cn_degree);
%Note that Counting 10-cycles will take several minutes. For codes of length 1000, the number of 10-cycles usually exceeds 10^7.
R = K/N;
max_iter = 50;
max_runs = 1e8;
resolution = 1e5;
ebno_vec = [1.5 2];
conste_name = 'BPSK';
max_err = 40;
%Supported constellation types:
%BPSK, QPSK, 16QAM, 64QAM, 256QAM, 4ASK, 8ASK, 16ASK. All in Gray Lableing.
%Naive Modulation, e.g., x1,x2,...,xm are mapped into one symbol and then transmitted
%BICM-style demodulation, i.e., independent bit level, one received symbol ¡û¡ú m LLRs
[num_block_err, num_bit_err, num_iter, num_runs] = simulation(ebno_vec, conste_name, P, H_row_one_absolute_index, H_comlumn_one_relative_index, N, M, K, vn_degree, cn_degree, ...
    vn_distribution, cn_distribution, max_iter, max_runs, resolution, max_err);
disp('BLER simulation is finished.')
bler = sum(num_block_err, 2)./sum(num_runs, 2);
ber = sum(num_bit_err, 2)./sum(num_runs, 2)/K;
ave_iter = sum(num_iter, 2)./sum(num_runs, 2);
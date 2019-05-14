function [M, N, K, vn_degree, cn_degree, P, H_row_one_absolute_index, H_column_one_relative_index, vn_distribution, cn_distribution] = H_matrix_process(H_input)
%H_input is the original very sparse matrix whose elements are in {0, 1} form.
%matrix P is used to produce parity-check-bits in a systematic code.
%matrix H indicates the location of 1's in H_input.
M = size(H_input, 1);
N = size(H_input, 2);
H_simplified_stair = Gaussian_Elimination(H_input);
K = N - size(H_simplified_stair, 1);%nmber of information bits.
[H_column_permuted, P] = H_systematic(H_simplified_stair, H_input);
%H_column_permuted is a permuted version of H_input, so H_column_permuted is still a sparse matrix.
%The column permutation of H is just equivalent to the permutation of VNs, therefore introducing no BLER loss.
disp(['The data-class of P is ' class(P)])
P = double(P);
%P itself maintains the initial input data structure as H_input (usually uint8 for space efficiency).
%Nevertheless, for the convenience in the later calculations, I convert it to DOUBLE.
[H_row_one_absolute_index, H_column_one_relative_index, vn_degree, cn_degree, vn_distribution, cn_distribution]  = extract_H_structure(H_column_permuted);
%[H_ones_indices, vn_degree, cn_degree] are parameters that describe the
%structure of H_column_permuted, not H_input.



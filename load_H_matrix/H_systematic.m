function [H, P] = H_systematic(H_simplified_stair, H_original)
N = size(H_simplified_stair, 2);
K = size(H_simplified_stair, 1);%note that here, K is the number of parity check bits
H = zeros(size(H_original, 1), N, 'uint8');
I_location = zeros(K, 1);
for i = N : -1 : 1
    index = find(H_simplified_stair(:, i));
    if (length(index) == 1) && (I_location(index) == 0)
       I_location(index) = i;
    end
end
if any(I_location ~= (N - K + 1 : N)')
    disp('Note that We are now permuting the columns of H_original to get systematic LDPC codes.')
    P_location = set_minus(1 : N, I_location);%{1,2,3,...,N}\I_location
    H(:, 1 : N - K) = H_original(:, P_location);
    H(:, N - K + 1 : N) = H_original(:, I_location);
    P = H_simplified_stair(:, P_location);
else
    disp('No Column Permutations.');
    H = H_original;
    P = H_simplified_stair(:, 1 : N - K);
end
end
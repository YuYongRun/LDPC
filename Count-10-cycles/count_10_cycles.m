function num_10_cycles = count_10_cycles(H, cn_degree)
num_10_cycles_vec = zeros(12, 1);
disp(' ');
disp('We are now counting the number of length-10-cycles in the target H.');
disp('Let us conut in parallel...This may take few minutes...')
parfor i_par = 1 : 12
    switch i_par
        case 1
            num_10_cycles_vec(i_par) = count_10_cycles_I(H, cn_degree);
        case 2
            num_10_cycles_vec(i_par) = count_10_cycles_II(H, cn_degree);
        case 3
            num_10_cycles_vec(i_par) = count_10_cycles_III(H, cn_degree);
        case 4
            num_10_cycles_vec(i_par) = count_10_cycles_IV(H, cn_degree);
        case 5
            num_10_cycles_vec(i_par) = count_10_cycles_V(H, cn_degree);
        case 6
            num_10_cycles_vec(i_par) = count_10_cycles_VI(H, cn_degree);
        case 7
            num_10_cycles_vec(i_par) = count_10_cycles_VII(H, cn_degree);
        case 8
            num_10_cycles_vec(i_par) = count_10_cycles_VIII(H, cn_degree);
        case 9
            num_10_cycles_vec(i_par) = count_10_cycles_IX(H, cn_degree);
        case 10
            num_10_cycles_vec(i_par) = count_10_cycles_X(H, cn_degree);
        case 11
            num_10_cycles_vec(i_par) = count_10_cycles_XI(H, cn_degree);
        case 12
            num_10_cycles_vec(i_par) = count_10_cycles_XII(H, cn_degree);
    end
end
num_10_cycles = sum(num_10_cycles_vec);
disp(' ');
disp(['The number of 10-cycles in the target H is ' num2str(num_10_cycles) '.'])
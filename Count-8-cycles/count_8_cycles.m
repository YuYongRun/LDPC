function num_8_cycles = count_8_cycles(H, cn)
num_8_cycles_vec = zeros(3, 1);
disp(' ');
disp('We are now counting the number of length-8-cycles in the target H.');
disp('Let us conut in parallel...This may take few seconds...')
parfor i_par = 1 : 12
    switch i_par
        case 1
            num_8_cycles_vec(i_par) = count_8_cycles_I(H, cn);
        case 2
            num_8_cycles_vec(i_par) = count_8_cycles_II(H, cn);
        case 3
            num_8_cycles_vec(i_par) = count_8_cycles_III(H, cn);
    end
end
num_8_cycles = sum(num_8_cycles_vec);
disp(' ');
disp(['The number of 8-cycles in the target H is ' num2str(num_8_cycles) '.'])

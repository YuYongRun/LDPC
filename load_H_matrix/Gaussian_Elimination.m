function H_input = Gaussian_Elimination(H_input)
N = size(H_input, 2);
M = size(H_input, 1);
level = 0;
for i = N : -1 : 1%Gaussian elimination
    next_column = 0;
    for j = 1 : M - level
        if H_input(j, i) == 1
            tmp = H_input(j, :);
            H_input(j, :) = H_input(M - level, :);
            H_input(M - level, :) = tmp;
            level = level + 1;
            break;
        else
            if j == M - level
                next_column = 1;
            end
        end
    end
    if next_column == 1
        continue;
    end
    for k = 1 : M - level%clear 1's upward
        if H_input(k, i) == 1
            H_input(k, :) = mod(H_input(k, :) + H_input(M - level + 1, :), 2);
        end
    end
    for k = M - level + 2 : M%clear 1's downward
        if H_input(k, i) == 1
            H_input(k, :) = mod(H_input(k, :) + H_input(M - level + 1, :), 2);
        end
    end
    if level == M
        break;
    end
end

rank_loss = 0;
while(all(H_input(1, :) == 0))
    H_input(1, :) = [];%delete all-0 row.
    rank_loss = rank_loss + 1;
end
if rank_loss ~= 0
    disp(['There is redundancy in H. The number of dependent rows is ' num2str(rank_loss) '.'])
else
    disp('The initial H is full row rank.')
end
end
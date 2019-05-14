function H = ProgressiveEdgeGrowthV2(N, M, Dv, DoYouWantACE)%Random PEG. If you want add ACE improvement, just set 'DoYouWantACE = 1'.
H = zeros(M, N, 'uint8');%Unsigned integer 8 is enough.
H_column_one_record = zeros(max(Dv), N);%This array is in fact not required. However, if you use it, the implementation speed will significantly improve.
H_column_one_record_index = ones(N, 1);
H_row_one_record = zeros(M, 2 * ceil(sum(Dv)/M));%This array is in fact not required. However, if you use it, the implementation speed will significantly improve.
H_row_one_record_index = ones(M, 1);
tree = zeros(N + M, 1, 'uint16');%N + M is the upper bound of the number of elements in the tree.
parent = zeros(N + M, 1, 'uint16');%Record the relationships in the tree.
CN_location = zeros(M, 1);%Record the relationships in the tree.
VN_location = zeros(N, 1);%Record the relationships in the tree.
%'tree' and 'parent' share the same counter.
marker = zeros(2 * M - 2, 2);%2M - 2 is the upper bound of the number of elements in the marker.
for v = 1 : N
    if mod(v, ceil(N/20)) == 1
        disp(['PEG LDPC under Construction. Now ' num2str(v/N*100) '%.']);
    end
    for k = 1 : Dv(v)%for each k, we add an '1' in H.
        if k == 1%get the 0-th level for k = 1
            row_weight = sum(H, 2);
            candidate_row = find(row_weight == min(row_weight));
            idx = unidrnd(length(candidate_row));%Random selection.
            H(candidate_row(idx), v) = 1;%Add an edge.
            H_column_one_record(H_column_one_record_index(v), v) = candidate_row(idx);
            H_column_one_record_index(v) = H_column_one_record_index(v) + 1;
            H_row_one_record(candidate_row(idx), H_row_one_record_index(candidate_row(idx))) = v;
            H_row_one_record_index(candidate_row(idx)) = H_row_one_record_index(candidate_row(idx)) + 1;
            continue;
        else%get the 0-th level for k >= 2
            level = 0;%refresh
            tree(1) = v;%refresh
            parent(1) = NaN;%The Root Node has no parent.
            tree_index = 1;%refresh
            VN_location(v) = tree_index;
            tree_index = tree_index + 1;
            marker(1, :) = [1 1];
            cn_level = find(H(:, v));
            marker(2, 1) = 2;
            for i = 1 : length(cn_level)
                tree(tree_index) = cn_level(i);
                parent(tree_index) = v;
                CN_location(cn_level(i)) = tree_index;
                tree_index = tree_index + 1;
            end
            marker(2, 2) = marker(2, 1) + length(cn_level) - 1;
            marker(3, 1) = marker(2, 2) + 1;
            marker(3, 2) = marker(2, 2);
        end
        level = level + 1;
        while(1)
            previous_cn = zeros(M, 1);
            previous_vn = zeros(N, 1);
            for k1 = 0 : level - 1
                for k2 = marker(2 * k1 + 1, 1) : marker(2 * k1 + 1, 2)
                    previous_vn(tree(k2)) = 1;
                end
                for k2 = marker(2 * k1 + 2, 1) : marker(2 * k1 + 2, 2)
                    previous_cn(tree(k2)) = 1;
                end
            end
            %Add VNs in this level.
            cannot_grow_flag = 1;
            for i = marker(2 * level, 1) : marker(2 * level, 2)
                for j = 1 : H_row_one_record_index(tree(i)) - 1
                    target_vn = H_row_one_record(tree(i), j);
                    if ~previous_vn(target_vn)
                        previous_vn(target_vn) = 1;
                        tree(tree_index) = target_vn;
                        parent(tree_index) = tree(i);
                        VN_location(target_vn) = tree_index;
                        tree_index = tree_index + 1;
                        marker(2 * level + 1, 2) = marker(2 * level + 1, 2) + 1;
                        cannot_grow_flag = 0;
                    end
                end
            end
            if cannot_grow_flag && sum(previous_cn) < M%This level is empty, i.e., no VNs can be added
                previous_cn_complementary = find(mod(previous_cn + 1, 2));
                row_weight = sum(H(previous_cn_complementary, :), 2);
                candidate_row = find(row_weight == min(row_weight));
                idx = unidrnd(length(candidate_row));%Random selection.
                H(previous_cn_complementary(candidate_row(idx)), v) = 1;
                H_column_one_record(H_column_one_record_index(v), v) = previous_cn_complementary(candidate_row(idx));
                H_column_one_record_index(v) = H_column_one_record_index(v) + 1;
                H_row_one_record(previous_cn_complementary(candidate_row(idx)), H_row_one_record_index(previous_cn_complementary(candidate_row(idx)))) = v;
                H_row_one_record_index(previous_cn_complementary(candidate_row(idx))) = H_row_one_record_index(previous_cn_complementary(candidate_row(idx))) + 1;
                break;%get rid of while(1). The following codes are not implemented in this case.
            end
            marker(2 * level + 2, 1) = marker(2 * level + 1, 2) + 1;
            marker(2 * level + 2, 2) = marker(2 * level + 1, 2);
            %Add CNs
            now_cn = previous_cn;
            for i = marker(2 * level + 1, 1) : marker(2 * level + 1, 2)
                for j = 1 : H_column_one_record_index(tree(i)) - 1
                    target_cn = H_column_one_record(j, tree(i));
                    if ~now_cn(target_cn)
                        now_cn(target_cn) = 1;
                        tree(tree_index) = target_cn;
                        parent(tree_index) = tree(i);
                        CN_location(target_cn) = tree_index;
                        tree_index = tree_index + 1;
                        marker(2 * level + 2, 2) = marker(2 * level + 2, 2) + 1;
                    end
                end
            end
            %Here, it seems that we should decide whether there is no new CN
            %being added into the tree. If so, the tree stops growing, and
            %we should add an '1' into the H matrix. However, this
            %operation is not necessary. The deliberately designed array 'marker' will
            %automatically guide the PEG process to the case where there is
            %no new VN being added in to the tree in the next level, i.e.,
            %we only need to see whether there is no new VNs being added.
            if sum(now_cn) == M %ALL CNs are included. Then we turn back to the last level, i.e., L - 1, to get the target CN.
                previous_cn_complementary = find(mod(previous_cn + 1, 2));
                row_weight = sum(H(previous_cn_complementary, :), 2);
                candidate_row = find(row_weight == min(row_weight));
                selected_cn = NaN;
                if DoYouWantACE
                    max_ACE = -realmax;
                    for i_ace = 1 : length(candidate_row)
                        involved_vn = zeros(level + 1, 1);
                        involved_cn = zeros(level + 1, 1);
                        involved_cn(1) = previous_cn_complementary(candidate_row(i_ace));
                        involved_vn(1) = parent(CN_location(involved_cn(1)));
                        for i_back = 2 : 2 * level + 1
                            if mod(i_back, 2) == 0
                                involved_cn(i_back/2 + 1) = parent(VN_location(involved_vn(i_back/2)));
                            else
                                involved_vn((i_back - 1)/2 + 1) = parent(CN_location(involved_cn((i_back - 1)/2 + 1)));
                            end
                        end
                        ACE = sum(sum(H(:, involved_vn))) - 2 * (level + 1);
                        if ACE > max_ACE
                            max_ACE = ACE;
                            selected_cn = previous_cn_complementary(candidate_row(i_ace));
                        end
                    end 
                else
                    idx = unidrnd(length(candidate_row));%Random selection.
                    selected_cn = previous_cn_complementary(candidate_row(idx));
                end
                H(selected_cn, v) = 1;
                H_column_one_record(H_column_one_record_index(v), v) = selected_cn;
                H_column_one_record_index(v) = H_column_one_record_index(v) + 1;
                H_row_one_record(selected_cn, H_row_one_record_index(selected_cn)) = v;
                H_row_one_record_index(selected_cn) = H_row_one_record_index(selected_cn) + 1;
                break;%get rid of while(1). The following codes are not implemented in this case.
            end
            marker(2 * level + 3, 1) = marker(2 * level + 2, 2) + 1;
            marker(2 * level + 3, 2) = marker(2 * level + 2, 2);
            level = level + 1;
        end
    end
end
function [H_row_one_absolute_index, H_column_one_relative_index, vn_degree, cn_degree, vn_distribution, cn_distribution]  = extract_H_structure(H)
vn_degree = sum(H);
cn_degree = sum(H, 2);
M = size(H, 1);
N = size(H, 2);
H_row_one_absolute_index = zeros(M, max(cn_degree));
for i = 1 : M
    cnt = 1;
    for j = 1 : N
        if H(i, j) == 1
            H_row_one_absolute_index(i, cnt) = j;
            cnt = cnt + 1;
        end
    end
end
H_column_one_relative_index = zeros(M, max(cn_degree));
for i = 1 : M
    for j = 1 : cn_degree(i)
        H_column_one_relative_index(i, j) = 1 + sum(H(1 : i - 1, H_row_one_absolute_index(i, j)));
    end
end
%VN degree polynomial
vn_distinct_degree_tmp = zeros(1, max(vn_degree));
for i = 1 : N
    vn_distinct_degree_tmp(vn_degree(i)) = vn_distinct_degree_tmp(vn_degree(i)) + 1;
end
distinct_degree = find(vn_distinct_degree_tmp);
degree_distribution = vn_distinct_degree_tmp(distinct_degree)/N;
vn_distribution = num2str([distinct_degree; degree_distribution]);

%CN degree polynomial
cn_distinct_degree_tmp = zeros(1, max(cn_degree));
for i = 1 : M
    cn_distinct_degree_tmp(cn_degree(i)) = cn_distinct_degree_tmp(cn_degree(i)) + 1;
end
distinct_degree = find(cn_distinct_degree_tmp);
degree_distribution = cn_distinct_degree_tmp(distinct_degree)/M;
cn_distribution = num2str([distinct_degree; degree_distribution]);

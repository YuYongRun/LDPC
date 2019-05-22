function [B_CN_absolute, B_CN_relative, B_VN_absolute, vn_degree, cn_degree]  = extract_B_structure(B)
M = size(B, 1);
N = size(B, 2);
vn_degree = sum(B ~= 0);
cn_degree = sum(B ~= 0, 2);
B_CN_absolute = zeros(M, max(cn_degree));
for i = 1 : M
    cnt = 1;
    for j = 1 : N
        if B(i, j)
            B_CN_absolute(i, cnt) = j;
            cnt = cnt + 1;
        end
    end
end
B_CN_relative = zeros(M, max(cn_degree));
for i = 1 : M
    for j = 1 : cn_degree(i)
        B_CN_relative(i, j) = 1 + sum(B(1 : i - 1, B_CN_absolute(i, j)) ~= 0);
    end
end
B_VN_absolute = zeros(max(vn_degree), N);
for j = 1 : N
    cnt = 1;
    for i = 1 : M
        if B(i, j)
            B_VN_absolute(cnt, j) = i;
            cnt = cnt + 1;
        end
    end
end



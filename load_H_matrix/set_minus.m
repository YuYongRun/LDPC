function C = set_minus(A, B)
%C = A\B
for i = 1 : length(A)
    if ismember(A(i), B)
        A(i) = -1;
    end
end
C = A(A > 0);
end
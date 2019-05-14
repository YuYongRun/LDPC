function num_10_cycles = count_10_cycles_VIII(H, cn)
num_10_cycles = 0;
M = size(H, 1);
for m1 = 1 : M - 4
    for i1 = 1 : cn(m1)
        index_1 = H(m1, i1);
        for m2 = m1 + 3 : M - 1
            for i2 = 1 : cn(m2)
                index_2 = H(m2, i2);
                if index_2 == index_1
                    for j1 = 1 : cn(m2)
                        index_3 = H(m2, j1);
                        if index_3 ~= index_2%horizontal comparison
                            for m3 = m1 + 1 : m2 - 2
                                for i3 = 1 : cn(m3)
                                    index_4 = H(m3, i3);
                                    if index_4 == index_3
                                        for j2 = 1 : cn(m3)
                                            index_5 = H(m3, j2);
                                            if index_5 ~= index_4 && index_5 ~= index_2%horizontal comparison
                                                for m4 = m2 + 1 : M
                                                    for i4 = 1 : cn(m4)
                                                        index_6 = H(m4, i4);
                                                        if index_6 == index_5
                                                            for j3 = 1 : cn(m4)
                                                                index_7 = H(m4, j3);
                                                                if index_7 ~= index_6 && index_7 ~= index_4 && index_7 ~= index_2%horizontal comparison
                                                                    for m5 = m3 + 1 : m2 - 1
                                                                        for i5 = 1 : cn(m5)
                                                                            index_8 = H(m5, i5);
                                                                            if index_8 == index_7
                                                                                for j4 = 1 : cn(m5)
                                                                                    index_9 = H(m5, j4);
                                                                                    if index_9 ~= index_8 && index_9 ~= index_3 && index_9 ~= index_5 && index_9 ~= index_2%horizontal comparison
                                                                                        for j5 = 1 : cn(m1)
                                                                                            index_10 = H(m1, j5);
                                                                                            if index_10 == index_9
                                                                                                num_10_cycles = num_10_cycles + 1;
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end                                   
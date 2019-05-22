clear

% vn_degree = [1 2 3 9];%dv - 1.
% vn_portion = [0.267 0.176 0.127 0.430];%edge portion
% cn_degree = [4 7];%dc - 1.
% cn_portion = [0.113 0.887];%edge portion

vn_degree = [1 2 5 6 7 8 9 27 29]; %dv - 1
vn_portion = [0.196 0.24 0.002 0.055 0.166 0.041 0.011 0.002 0.287];
cn_degree = [7 8 9]; %dc - 1
cn_portion = [0.007 0.991 0.002];

I_AV = 0.001 : 0.001 : 0.999;
I_EV = zeros(length(I_AV), 1);
EbN0 = 0.5;%dB
R = 0.5;
sigma_ch = sqrt(8 * R * 10^(EbN0/10));%sigma_ch^2 = 4 sigma_w^2 = 8 R Eb/N0.
for i = 1 : length(I_AV)
    for i_vn = 1 : length(vn_degree)
        I_EV(i) = I_EV(i) + vn_portion(i_vn) * J(sqrt(vn_degree(i_vn) * Jinv(I_AV(i))^2 + sigma_ch^2));
    end
end
plot(I_AV, I_EV);
hold on;

I_AC = 0.001 : 0.001 : 0.999;
I_EC = zeros(length(I_AC), 1);
for i = 1 : length(I_AC)
    for i_cn = 1 : length(cn_degree)
        I_EC(i) = I_EC(i) + cn_portion(i_cn) * (1 - J(sqrt(cn_degree(i_cn) * Jinv(1 - I_AC(i))^2)));
    end
end
plot(I_EC, I_AC);
hold on;

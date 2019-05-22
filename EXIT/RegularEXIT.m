% clear
dv = 3;
dc = 6;
I_AV = 0.001 : 0.001 : 0.999;
I_EV = zeros(length(I_AV), 1);
EbN0 = 1.1;%dB
R = 0.5;
sigma_ch = sqrt(8 * R * 10^(EbN0/10));%sigma_ch^2 = 4 sigma_w^2 = 8 R Eb/N0.
for i = 1 : length(I_AV)
    I_EV(i) = J(sqrt( (dv - 1) * Jinv(I_AV(i))^2 + sigma_ch^2));
end
plot(I_AV, I_EV);
hold on;
I_AC = 0.001 : 0.001 : 0.999;
I_EC = zeros(length(I_AC), 1);
for i = 1 : length(I_AC)
    I_EC(i) = 1 - J(sqrt((dc - 1) * Jinv(1 - I_AC(i))^2));
end
plot(I_EC, I_AC);
hold on;
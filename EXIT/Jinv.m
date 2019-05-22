function y = Jinv(I)
% fun = @(I, sigma) J(sigma) - I; % function
% % initial point selction
% if I >= 0.8
%     x0 = 4; 
% else
%     if I < 0.01
%         x0 = 0.2;
%     else
%         if I < 0.16
%             x0 = 1;
%         else
%             x0 = 2;
%         end
%     end
% end
% y = fzero(@(sigma) fun(I, sigma), x0);

%Approximation From 'Design of Low-Density Parity-Check Codes for Modulation and Detection'
if I >= 0 && I <= 0.3646
    y = 1.09542 * I^2 + 0.214217 * I + 2.33727 * sqrt(I);
else
    y = -0.706692 * log(0.386013 * (1 - I)) + 1.75017 * I;
end
if y == inf
    y = 1e20;
end
end
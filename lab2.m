% Data Setup for Ad Lib Marketing
E = [
     0, 20,  9,  1, 11,  0, 40;
     0,  8,  7,  1, 10,  0,  0;
    60,  0,  0,  0,  0,  9, 11;
     1,  0,  0,  0,  0, 40, 40;
     0, 30,  3,  4, 13,  9,  0
];

MinExp = [40, 12, 110, 110, 16, 13, 60];
SatLevel = [140, 140, 140, 120, 50, 150, 90];
MaxExcess = SatLevel - MinExp;

num_media = 5;
num_markets = 7;

% Optimization Parameters
f = [zeros(1, num_media), -ones(1, num_markets)];
A_exp = [-E', eye(num_markets)];
b_exp = -MinExp';
lb = zeros(num_media + num_markets, 1);
ub = [inf(num_media, 1); MaxExcess'];

% Sweep Budget with High Internal Precision
budget_values = 31:0.001:34;
max_exposures = zeros(size(budget_values));

% Suppress MATLAB text output during the loop
options = optimoptions('linprog', 'Display', 'off');

for k = 1:length(budget_values)
    current_budget = budget_values(k);
    A = [A_exp; ones(1, num_media), zeros(1, num_markets)];
    b = [b_exp; current_budget];
    
    [~, fval, exitflag] = linprog(f, A, b, [], [], lb, ub, options);
    
    if exitflag == 1
        max_exposures(k) = -fval; 
    else
        max_exposures(k) = NaN;
    end
end

% Identify the Corner Point
slopes = round(diff(max_exposures) ./ diff(budget_values), 4);
change_index = find(diff(slopes) < -0.01, 1);

if ~isempty(change_index)
    corner_budget = budget_values(change_index + 1);
    fprintf('The corner point to enter is: %.1f\n', corner_budget);
else
    disp('No corner point detected.');
end
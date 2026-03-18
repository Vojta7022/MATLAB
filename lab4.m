% Two-Person Zero-Sum Game LP Solver
% Finding the minimax strategies for Blue and Gold

% Payoff Matrix (Rows = Gold's moves, Cols = Blue's moves)
% The values represent the payoff from Blue to Gold
P = [
    -12,  -3,  20, -20,  10;
      3, -15,  10,  19, -19;
      3,  20,  -7,   4,  -6
];

[num_gold, num_blue] = size(P);

% Suppress text output during the optimization process
options = optimoptions('linprog', 'Display', 'off');

% --- Blue's Strategy (Minimize Maximum Loss) ---
% Variables: [LB, BMa, BMb, BMc, BMd, BMe]
f_blue = [1; zeros(num_blue, 1)];

% Inequality Constraints: -LB + P * BM <= 0
A_blue = [-ones(num_gold, 1), P];
b_blue = zeros(num_gold, 1);

% Equality Constraint: sum(BM) = 1
Aeq_blue = [0, ones(1, num_blue)];
beq_blue = 1;

% Bounds: LB is unbounded, BM_i >= 0
lb_blue = [-inf; zeros(num_blue, 1)];

[x_blue, ~] = linprog(f_blue, A_blue, b_blue, Aeq_blue, beq_blue, lb_blue, [], options);

% Simplify the results
BM = round(x_blue(2:end), 4); 

% --- Gold's Strategy (Maximize Minimum Profit) ---
% Variables: [PG, GMa, GMb, GMc]
f_gold = [-1; zeros(num_gold, 1)];

% Inequality Constraints: PG - P^T * GM <= 0
A_gold = [ones(num_blue, 1), -P'];
b_gold = zeros(num_blue, 1);

% Equality Constraint: sum(GM) = 1
Aeq_gold = [0, ones(1, num_gold)];
beq_gold = 1;

% Bounds: PG is unbounded, GM_i >= 0
lb_gold = [-inf; zeros(num_gold, 1)];

[x_gold, ~] = linprog(f_gold, A_gold, b_gold, Aeq_gold, beq_gold, lb_gold, [], options);

% Simplify the results
GM = round(x_gold(2:end), 4); 

% --- Display the final numbers ---
fprintf('\nBlue''s Probabilities:\n');
fprintf('BM_a = %g\n', BM(1));
fprintf('BM_b = %g\n', BM(2));
fprintf('BM_c = %g\n', BM(3));
fprintf('BM_d = %g\n', BM(4));
fprintf('BM_e = %g\n', BM(5));

fprintf('\nGold''s Probabilities:\n');
fprintf('GM_a = %g\n', GM(1));
fprintf('GM_b = %g\n', GM(2));
fprintf('GM_c = %g\n', GM(3));
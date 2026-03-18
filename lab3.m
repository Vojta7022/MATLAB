% PERT Network LP Solver
% Variables 1 to 22 represent the start times of Activities A1 to A22.
% Variable 23 represents the Finish Time of the entire project.

durations = [15, 22, 14, 11, 14, 10, 8, 8, 24, 4, 3, 14, 13, 21, 4, 3, 2, 6, 9, 13, 9, 16];

% Define predecessor relationships (Source Node, Target Node)
edges = [
    2,4; 5,4; 
    3,5; 
    1,6; 4,6; 
    2,7; 5,7; 
    3,8; 
    3,9; 
    3,10; 
    6,11; 7,11; 8,11; 
    9,12; 11,12; 
    6,13; 7,13; 8,13; 
    6,14; 7,14; 8,14; 
    6,15; 7,15; 8,15; 
    9,16; 11,16; 
    10,17; 12,17; 
    13,18; 
    14,19; 18,19; 
    13,20; 
    14,21; 18,21; 
    15,22; 16,22; 17,22; 19,22
];

num_activities = 22;
num_vars = num_activities + 1; 

% Objective: Minimize the Finish Time (Variable 23)
f = zeros(1, num_vars);
f(num_vars) = 1;

% Build inequality constraints: A * x <= b
num_edges = size(edges, 1);
num_constraints = num_edges + num_activities;
A = zeros(num_constraints, num_vars);
b = zeros(num_constraints, 1);

% Constraint type 1: Start_target >= Start_source + duration_source
for i = 1:num_edges
    u = edges(i, 1);
    v = edges(i, 2);
    A(i, u) = 1;
    A(i, v) = -1;
    b(i) = -durations(u);
end

% Constraint type 2: Finish >= Start_node + duration_node
row_offset = num_edges;
for i = 1:num_activities
    A(row_offset + i, i) = 1;
    A(row_offset + i, num_vars) = -1;
    b(row_offset + i) = -durations(i);
end

% Lower bounds: all start times and finish time must be >= 0
lb = zeros(num_vars, 1);

% Solve the LP silently
options = optimoptions('linprog', 'Display', 'off');
[x, fval] = linprog(f, A, b, [], [], lb, [], options);

% Display the result
fprintf('The least amount of time needed to complete the project is: %.0f\n', fval);
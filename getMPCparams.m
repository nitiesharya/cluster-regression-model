Q = [1 1 1];                      % State weights
R = 0.001;                        % du weights
Ru = 0.001;                       % u weights
C = eye(Nvar);
D = 0;
LB = -200*ones(N,1);        % Lower bound of control input
UB = 200*ones(N,1);         % Upper bound of control input


%sweep values Q R Ru
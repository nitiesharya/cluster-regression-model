function [x,x_V,u,u_V,tspan,tspan_V] = DATA_GENERATION(dt,T,x0)
%% Get training data
InputSignalTypeModel = 'sphs'; % prbs; chirp; noise; sine2; sphs; mixed
ONLY_TRAINING_LENGTH = 1;
InputSignalType = InputSignalTypeModel;% prbs; chirp; noise; sine2; sphs; mixed
%Ndelay = Models.DelayDMDc.Ndelay;
getTrainingData;

%% Get testing data
x0 = x(end,:);
tspan_V =[tspan(end):dt:20];
t_valid = tspan_V';
%% FIGURE 1:  // Model comparison + Validation
% Forcing

forcing = @(x,t) (5*sin(30*t)).^3;
u = u.';   %training u

% Reference
[tA,x_V] = ode45(@(t,x)LorenzSys(t,x,forcing(x,t),p),tspan_V,x(end,1:3),options);   % true model
u_V = forcing(0,tA)';   %validation u

u_V = u_V.';
end
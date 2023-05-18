function [ y ] = dnf_net_revised(sigma,A, C)
% Dynamic neural fields
% Written specifically for MBM 2013, University of Birmingham by  Dietmar
% Heinke, with some minor revisions by Howard Bowman in 2015

% parameters not to be changed in this exercise
s=0.6; % Threshold/ offset for sigmoid function
m=3;  % slope for sigmoid function
dt=0.1 / 5; % size of time step
nn=101; % number of neurons
nos = 400; % number of time steps
steps_switchoff = round(nos/2); % time of removal of external input
% -------------------------------

if nargin <1
    
    %if no input variables are given
    % Set default value for sigma (controls the spatial influence 
    % between neurons)
    sigma = 0.7;
    % -----------------
    
    % Set default value for A (determines the strength of the excitatory 
    % connections between neurons)
    A =     2;
    % -----------------
    
    % Set default value for C (represents the level of inhibition in 
    % the neural field)
    C =     1.0;
    %--------------
end

if nargin > 1 & nargin<3
    error('Not enough inputs');
end

if nargin<4
    
end

% Create external input matrix
I = zeros(nn,nos);
I(50,:) = [ones(1,steps_switchoff) zeros(1,nos-steps_switchoff)];
%----------------

% Calculate weights matrix
i=[-50:50] / 50;
for k=1:nn
    w(k,:) = A * exp(-(i-((k-51)/50)).^2 / sigma^2) - C;
end
% -----------------------


% Initialize neural field
x = zeros(nn,nos);
%--------------------------


close all


% Simulation of DNF
for i=2:nos;
    
    % Calculate change in activity (dx) at each time step
    dx= -x(:,i-1) + w*sigmoid(x(:,i-1),m,s) + I(:,i);
    %--------------------------------------------------
    
    % Update neural field activity
    x(:,i)=x(:,i-1)+dt*dx;
    %----------------------
end

% calculation of output activation 
y = sigmoid(x',m,s);

% plotting
surf(y(1:4:end,:), 'linestyle', 'none');  
title('Neural field output')
ylabel('timestep', 'fontsize', 12);
xlabel('neuron', 'fontsize', 12);
axis([0 101 0 nos/4 0 1]);
set(gca, 'yticklabel', {'0' '100', '200', '300' '400'});
view(54,66)
end

function yy = sigmoid(xx,mm,ss)
%
% yy = sigmoid(xx,mm,ss) computation for the sigmoid-function.
%

yy = 1 ./ (1+exp(-mm*(xx-ss)));

end
%invpendulum - Implementation of an inverted pendulum model 
%   Used in MBM 2020/2021 to demonstrate scripting for workshop 4
%   Will be distributed through Canvas
%   Students will rename the script adding their ID to the name
%
%   Description:
%       lab4 involves the analysis and control of an inverted pendulum
%       system with the dynamic equation of motion
%
%   Other m-files required: none
%   MAT-files required: none
%

%   Author: Marcus Rank
%   Date: 06/02/2014 
%
%   Revisions:
%   Date: 06/01/2020
%   Author: Chris Miall
% 
%   Last revision: 01/03/2021
%   Author: Max Di Luca

function [simulationresults,state,t,gains,Movie] = invpendulum_loop(stop_time)
% run as usual by clicking on Run button in the editor
% or run by typing [xx,yy,etc]=filename; *filename should be the same as
% the function name to avoid confusion 
%
% it can return any internal state variables, the time steps,the gains and 
% a Movie of the simulation e.g.
%       [state,~,gains]=filename;
%
% If you want to "freeze" it at any moment, enter a fraction and it will 
% stop plotting after that proportion of normal run time. This may be useful 
% to capture the plot at a particular moment
% e.g. [state,~,gains]=filename(0.33) 
% will stop the plot after 33% of the normal 15 second simulation time, but 
% continue to run the simulation and return the full state varaibles.
%

% variable declaration
global m_pendulum l_pendulum g inertia h
h = []; % initialise figure handle
l_pendulum = 1; % pendulum length
m_pendulum = 0.5; % pendulum mass
inertia=0.1; %damping coefficient
g = 9.81; %gravity constant
Ts = 0.02; % sampling time of the simulation
stop_time=10;
t = 0:Ts:stop_time; % time vector

%set this to false to avoid real-time display, when attempting the search
%of parameter space for task 5
plotting = false; 
 
slow_flag=false; % flag indicating slow computation of simulations

%tau_dist: a vector of the same size as t (time), containing disturbance 
%torques (rotational forces, clockwise positive) for every time step
%Task 1
tau_dist = zeros(size(t));
tau_dist(t==1)=30;


state = [0 0 0 0];

simulationresults = [];

for ka=100:10:350
for kd=10:2:20
state = [0 0 0 0];
%pendulum angular gains
Ka = -ka; %proportional gain
Da = -50; %differential gain  

%cart positional gains
Kp = -kd; %proportional gain
Dp = -20; %differential gain
    
for idx = 2:length(t) % execute the following every time step
    
    tic %a timer is set up to time the duration of the simulation
    
    %a_cart: this defines the acceleration to be applied to the cart

    a_cart=0; %the initial version of the code is for no control. You will
    %need to change the value of a_cart to achieve control. So Tasks 2-5 
    %require a control algorithm here, measuring error and applying a gain
    %term to scale the error into a useful control signal
    
    %save these in a structure in case they are needed as return values
    gains=struct('Ka',Ka,'Da',Da,'Kp',Kp,'Dp',Dp);
    
    goal = [0 0 0 0];
        
    a_cart1=Ka*(state(end,1)-goal(1))+Da*(state(end,2)-goal(2));
    a_cart2=Kp*(state(end,3)-goal(3))+Dp*(state(end,4)-goal(4)); 

    a_cart=a_cart1+a_cart2;
    
    %this is not strictly necessary but is useful
%    if abs(a_cart) >1000 || abs(state(idx-1,3)) >100
%     disp('Simulation has exceeded useful range, and is stopping now');  
%     return
%    end
    
    %% simulate of the system dynamics
    %you do not need to worry about this, it solves the ordinary 
    %differential equations necessary to simulate the physics of the cart 
    %and its pendulum. It is only approximate, and both the cart and the 
    %pendulum have a simple ODE simulation where acceleration is approximated 
    %by change in state velocity in each simulation cycle. For 2019, I have 
    %added in a common inertia term to both, to add some damping.
    sys_input = [a_cart, tau_dist(idx)];
    [~, nextstate] = ode23(@(time,state_var)dyn_pendulum(time,state_var,sys_input),[0 Ts],state(idx-1,:)');
    %update the state vector with new values
    state(idx,:) = nextstate(end,:);
       
    %% plotting the simulation (with option "freeze" after stop_time fraction)
    if plotting
        if ~nargin
            h = plot_invpendulum(idx,length(t),state(idx,3),state(idx,1),a_cart,h);
        else
            if idx<=length(t)*stop_time
                h = plot_invpendulum(idx,length(t),state(idx,3),state(idx,1),a_cart,h);
                %if required, store the simulation as a movie structure
                if nargout==4
                    Movie(idx-1)=getframe(h);
                end
            end
        end
        
        %wait for any remaining time
        time_delay=Ts-toc;
        pause(time_delay)
        
        %onscreen update
        if mod(idx,round(length(t)/10))==0
            fprintf('%i%% done\n',round(100*idx/length(t)));
        end
        
        %check if simulation and plotting time is taking too long
        if idx>2 && time_delay<0.0
            slow_flag=true;
        end
    end
end

if slow_flag
    disp('Simulation running too slow; increase step-size Ts to allow more time');
end
simulationresults = [simulationresults; ka kd sum(state(end,3))];
end
end
% eventually output something - these outputs could be used to plot the
% state of the simulation against time, for example

%% Helper Functions after here - you should not change any of this code 

function s_d = dyn_pendulum(~,s,input)
%% dynamics equation for simulation
global m_pendulum l_pendulum g inertia
  
alpha = s(1); %pendulum angle
alpha_d = s(2); %pendulum angular velocity
x = s(3); %cart position
x_d = s(4); %cart velocity

x_dd = -input(1)-inertia*x_d; %cart acceleration (the control signal)
tau_dist = input(2);

alpha_dd = g/l_pendulum * sin(alpha) - 1/l_pendulum * cos(alpha) * x_dd + 1/(m_pendulum*l_pendulum^2) * tau_dist -inertia*alpha_d;

s_d = [alpha_d; alpha_dd; x_d; x_dd]; %the state difference


function h = plot_invpendulum(t1,tmax,x,alpha,acc,varargin)
%% plotting function
% plots the cart and the inverted pendulum at cart position x, tilted by
% angle alpha [in radians] in an axis with handle h

global l_pendulum

%origin labels
o_label = round(x/10)*10 + [-4 -2 0 2 4];

%range around cart position
if abs(x)>5
    x = x-round(x/10)*10;
end

%pendulum
p_xdata = [x x+l_pendulum*sin(alpha)];
p_ydata = [0.2 0.2+l_pendulum*cos(alpha)];

%cart
c_xdata = [x-0.5 x+0.5];
c_ydata = [0.2 0.2];

%acceleration
a_xdata = [x x-acc];
a_ydata = [0 0];

%timebar
t_xdata = [-5 -5+10*(t1/tmax)];
t_ydata = [-1.0 -1.0];

if nargin==6 && ~isempty(varargin{1}) % if optional argument is supplied and not empty
    h = varargin{1};                  % use the options
else
    h = figure('Position',[100 100 1000 500]);
    plot([-5 5],[0 0],'k-');
    hold on
    axis equal
    ylim([-1.1 2.1]);
    xlim([-5 5]);
    title('Inverted Pendulum, wait for completion')
end

p = findobj(h,'Tag','pendulum');
o = findobj(h,'Tag','origin');
a = findobj(h,'Tag','acceleration');
t = findobj(h,'Tag','timeline');

if isempty(p)
    hold on
    p = plot(p_xdata,p_ydata,'r-s','LineWidth',4,'MarkerSize',6,'Tag','pendulum');
    set(p,'XDataSource','p_xdata','YDataSource','p_ydata');
else
    refreshdata(p,'caller');
end

if isempty(o)
    hold on
    o = plot(c_xdata ,c_ydata,'k-o','LineWidth',6,'MarkerSize',25,'Tag','origin');
    set(o,'XDataSource','c_xdata','YDataSource','c_ydata');
else
    refreshdata(o,'caller');
end

if isempty(a)
    hold on
    a = plot(a_xdata,a_ydata,'b-d','LineWidth',2,'Tag','acceleration');
    set(a,'XDataSource','a_xdata','YDataSource','a_ydata');
else
    refreshdata(a,'caller');
end

if isempty(t)
    hold on
    t = plot(t_xdata,t_ydata,'g-','LineWidth',5,'Tag','timeline');
    set(t,'XDataSource','t_xdata','YDataSource','t_ydata');
else
    refreshdata(t,'caller');
end
%drawnow;
set(gca,'XTick',[-4 -2 0 2 4],'XTickLabel',o_label,'YTick',[]);
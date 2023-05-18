%labsync - Partial implementation of the assigment in the MBM workshop
%
%   Description: the script instantiates a clapping agent, clapping 6 times once every second to check how it
%   maintains constant period despite stdClappingError and can be used to start the implementation of
%   pairs of agents
%
%   Other m-files required: clappingAgent.m
%   MAT-files required: none
%

%   Author: Max Di Luca
%   email: m.diluca@bham.ac.uk 
%   Date: 14/03/2021
%
%   Last revision: 8/5/23, Darshan, Added a second agent and plotted the
%   Clapping Agents

clear all
clc

rng(1)

% Initializing the correction, error and period variables
selfCorrection=0;
stdClappingError=0.1;
period=1;
alphaOther=-0.5;

% Setting the initial Clap times
initialClapTime=0;
initialClapTime2=0;

% Create two clapping agents with the same selfCorrection and alphaOther values
agentPointer=clappingAgent([selfCorrection alphaOther],stdClappingError,period);
agentPointer2=clappingAgent([selfCorrection alphaOther],stdClappingError,period);

% Set the initial clap times for each agent
agentPointer=setClapTime(agentPointer,initialClapTime);
agentPointer2=setClapTime(agentPointer2,initialClapTime2);

% Get the initial clap times for each agent
clapTime=getClapTime(agentPointer)
clapTime2=getClapTime(agentPointer2)

%error=clapTime;
%agentPointer=playClap(agentPointer,error);
%clapTime=getClapTime(agentPointer)

clf 
hold on

%plot(0,clapTime,'*')

for n=0:20

% Calculate the error between the clap times of the two agents
%error=clapTime-period
error=clapTime-clapTime2;
error1=clapTime2-clapTime;
%error=clapTime-period*n;

% Update the agents' clap times based on the errors
agentPointer=playClap(agentPointer,error);
agentPointer2=playClap(agentPointer2,error);

% Get the updated clap times for each agent
clapTime=getClapTime(agentPointer)
clapTime2=getClapTime(agentPointer2)

% Plot the clap times of each agent as a function of clap number
plot(n,clapTime-period*(n),'r*')
plot(n,clapTime2-period*(n),'b*')
xlabel('Clap Number')
ylabel('Time')
title('Clap Behaviour for 2 Agents')
end

% Calculating the clap times individually without using loops
error=clapTime-period*2;
agentPointer=playClap(agentPointer,error);
clapTime=getClapTime(agentPointer)

error=clapTime-period*3;
agentPointer=playClap(agentPointer,error);
clapTime=getClapTime(agentPointer)

error=clapTime-period*4;
agentPointer=playClap(agentPointer,error);
clapTime=getClapTime(agentPointer)

figure(1)

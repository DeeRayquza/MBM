%runSchelling - Simulation of Schelling model
%   Used in MBM 2022/2023 for workshop 5
%   Will be distributed through Canvas
%
%   Description:
%       lab5 involves the simulation and analysis of a series of agents in a
%       matrix
%
%   Other m-files required: none
%   MAT-files required: none
%

%   Author: Dietmar Heinke


function [agentGrid] = runSchelling(gridSize, nGroup1, nGroup2, tolerance)
%
% [agent_grid] = schelling(gridSize, nGroup1, nGroup2, tolerance)
%


N_ITERATIONS = 50;

% Initialize the agent grid with zeros
agentGrid = zeros(gridSize,gridSize);
% -------------------------------------------------------------------------


% Populate the grid with agents from group 1
[m,n] = find(agentGrid == 0);
for igroup=1:nGroup1
    x = length(m);
    r = randi(x,1);
    agentGrid(m(r), n(r)) = 1;
    m(r) = [];
    n(r) = [];
end
% -------------------------------------------------------------------------


% Populate the grid with agents from group 2
[m,n] = find(agentGrid ~= 1);

if length(m) <= nGroup2
    error('no more space left to place agents');
end

for y=1:nGroup2
    x = length(m);
    r = randi(x,1);
    agentGrid(m(r), n(r)) = -1;

    m(r) = [];
    n(r) = [];
end
% -------------------------------------------------------------------------


% Initialize an array to store the segregation values at each time step
seg = nan(N_ITERATIONS,1);
for time=1:N_ITERATIONS

    move_grid = zeros(size(agentGrid));
    [n, ~] = size(agentGrid);

    % Find the locations of all the agents on the grid
    [yLoc, xLoc] = find(agentGrid ~= 0);
    nAgent = length(yLoc);
    % ---------------------------------------------------------------------


    % Calculate the segregation index and plot the current grid
    seg(time) = calcSegregation(agentGrid);
    subplot(1,2,1);
    imshow(agentGrid, [], 'InitialMagnification','fit');
    subplot(1,2,2); plot(seg); xlabel('time'); ylabel('segregation'); axis([0 time 0.4 1])
    drawnow
    pause(0.3)
    % ---------------------------------------------------------------------


    % Loop through each agent and determine if they want to move
    for iAgent=1:nAgent
        y = yLoc(iAgent); x = xLoc(iAgent);
        same = 0;
        diff = 0;

        % Check the neighbors of the current agent to determine if they are
        % in the same or different group
        for iMove=-1:1
            for p=-1:1

                ik = wrap_around(y+iMove, n);
                jp = wrap_around(x+p, n);
                if ~((iMove == 0) & (p == 0))

                    if agentGrid(ik, jp) == agentGrid(y,x)
                        same = same + 1;
                    end

                    if (agentGrid(ik, jp) ~= 0) && (agentGrid(ik, jp) ~= agentGrid(y,x))
                        diff = diff + 1;
                    end
                end
            end
        end
        % -----------------------------------------------------------------



        % Implement decision rule
        % Check if the agent is unhappy based on the tolerance level
                 if same/(same+diff) < tolerance % DECISION RULE
                     move_grid(y,x) = 1; % Set the move_grid value to 1 to indicate that the agent wants to move
                 end
        % -----------------------------------------------------------------

    end
    % ---------------------------------------------------------------------

    % Move unhappy agents
    [yLocMove, xLocMove] = find(move_grid == 1);
    [yLoc, xLoc] = find(agentGrid == 0);
    % -----------------------------------------------------------------

    % Check if both yLocMove and n are not empty before proceeding with the condition
    if isempty(yLocMove) == 0 && isempty(n) == 0
        for iMove=1:length(yLocMove)
            r = randi(length(yLoc),1);

            agent_h = agentGrid(yLocMove(iMove), xLocMove(iMove));
            y_h = yLocMove(iMove);
            x_h = xLocMove(iMove);
            agentGrid(yLocMove(iMove), xLocMove(iMove)) = 0;

            agentGrid(yLoc(r), xLoc(r)) = agent_h;
            yLoc(r) = y_h;
            xLoc(r) = x_h;

        end
    else
        break
    end
    % -------------------------------------------------------------------------


end
% -------------------------------------------------------------------------



end

function seg = calcSegregation(agentGrid)

[rowSize, colSize] = size(agentGrid);

% Find agents' position on the grid
[rowAgent, colAgent] = find(agentGrid ~= 0);
nAgent = length(rowAgent);


% goes through all agents
for iAgent=1:nAgent
    iRow = rowAgent(iAgent); iCol = colAgent(iAgent);
    sameGroup = 0;
    diffGroup = 0;
    % counts the number of same agents and different agents surrounding one
    % agent
    for i=-1:1
        for j=-1:1
            ik = wrap_around(iRow+i, rowSize);
            jp = wrap_around(iCol+j, rowSize);
            if ~((i == 0) && (j == 0))

                if agentGrid(ik, jp) == agentGrid(iRow,iCol)
                    sameGroup = sameGroup + 1;
                end

                if (agentGrid(ik, jp) ~= 0) && (agentGrid(ik, jp) ~= agentGrid(iRow,iCol))
                    diffGroup = diffGroup + 1;
                end
            end
        end
    end
    if (sameGroup+diffGroup) ~= 0
        seg_h(iAgent) = sameGroup / (sameGroup+diffGroup);
    else
        seg_h(iAgent) = 0;
    end
end

seg = mean(seg_h);
end



function i = wrap_around(j, n)


i = j;
if j < 1
    i = n - j;
end
if j > n
    i = j - n;
end
end


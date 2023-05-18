% Define car speed
car_speed = 60; % mph

% Define sampling rate
Fs = 100; % Hz

% Define time duration of simulation
duration = 10; % seconds

% Create time vector
t = linspace(0, duration, duration*Fs);

% Define road motion
road_motion = 0.1*sin(2*pi*5*t);

% Define interior motion
interior_motion = 1*sin(2*pi*1*t);

% Define observer's point of view
observer_view = 'external';

% Initialize figure array
fig_array = [];

% Loop through time steps
for i = 1:length(t)
    
    % Calculate perceived speed
    if strcmp(observer_view, 'interior')
        perceived_speed = car_speed + interior_motion(i) - road_motion(i);
    elseif strcmp(observer_view, 'external')
        perceived_speed = car_speed + road_motion(i);
    end
    
    % Calculate distance traveled by car
    distance_traveled = perceived_speed * (t(i) - t(1))/3600; % convert to miles
    
    % Calculate road and car positions
    road_position = road_motion(i) * distance_traveled;
    car_position = road_position - distance_traveled;
    
    % Set plot limits
    xlim([0, max(distance_traveled, 0.1)]);
    ylim([-0.1, 0.1]);
    
    % Plot road and car positions
    plot([0, max(distance_traveled, 0.1)], [0, 0], 'k', 'LineWidth', 2);
    hold on;
    plot(road_position, 0, 'b.', 'MarkerSize', 50);
    plot(car_position, 0, 'r.', 'MarkerSize', 50);
    
    % Set plot labels and title
    xlabel('Distance (miles)');
    ylabel('Position (miles)');
    title(['Perceived Motion from ', observer_view, ' viewpoint - t = ', num2str(t(i)), 's']);
    
    % Capture current figure and add to figure array
    fig_array = [fig_array, getframe(gcf)];
    
    % Clear figure for next iteration
    clf;
    
end

% Convert figure array to gif file
im2gif(fig_array, 'perceived_motion.gif');

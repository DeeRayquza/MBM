% Define parameters
train_speed = 50; % km/h
observer_distance = 5; % m
object_distance = 10; % m
object_speeds = [0, 10, -10]; % m/s
time_step = 0.1; % seconds
duration = 10; % seconds

% Initialize arrays
time_array1 = 0;
perceived_speed_array1 = 0;
time_array2 = 0;
perceived_speed_array2 = 0;
observer_distance_array2 = 0;

% Initialize variables
observer_position = observer_distance;
object_position = object_distance;
time = 0;

% Simulate motion without observing object
while time < duration
    % Update observer position
    observer_position = observer_position + (train_speed/3.6) * time_step;
    
    % Calculate perceived speed
    perceived_speed1 = train_speed * (object_distance - observer_position) / (object_distance + observer_position);
    
    % Update time
    time = time + time_step;
    
    % Store results
    time_array1(end+1) = time;
    perceived_speed_array1(end+1) = perceived_speed1;
end

% Simulate motion while observing object
for object_speed = object_speeds
    % Reset variables
    observer_position = observer_distance;
    object_position = object_distance;
    time = 0;
    
    while time < duration
        % Update observer and object positions
        observer_position = observer_position + (train_speed/3.6) * time_step;
        object_position = object_position + (object_speed) * time_step;
        
        % Calculate perceived speed
        perceived_speed2 = train_speed * (object_distance + object_position - observer_position) / (object_distance + observer_position);
        
        % Update time
        time = time + time_step;
        
        % Store results
        time_array2(end+1) = time;
        perceived_speed_array2(end+1) = perceived_speed2;
        observer_distance_array2(end+1) = observer_position - object_position;
    end
end

% Plot results
figure(1);
plot(time_array1, perceived_speed_array1, 'b-', 'LineWidth', 2);
hold on;
plot(time_array2, perceived_speed_array2, 'r-', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Perceived speed (km/h)');
legend('Without observing object', 'While observing object');
grid on;

figure(2);
plot(observer_distance_array2, perceived_speed_array2, 'r-', 'LineWidth', 2);
xlabel('Distance to observed object (m)');
ylabel('Perceived speed (km/h)');
grid on;

% Define hand model
xRA = -5:0.8:5;
yRA = -5:0.8:5;
xSA1 = -5:1.2:5;
ySA1 = -5:1.2:5;
xPC = -5:2:5;
yPC = -5:2:5;

RA = struct('type', 'RA', 'x', xRA, 'y', yRA);
SA1 = struct('type', 'SA1', 'x', xSA1, 'y', ySA1);
PC = struct('type', 'PC', 'x', xPC, 'y', yPC);

hand = [RA SA1 PC];

% Define stimulus
t = 0:0.001:2;
f = 50;
sine_wave = sin(2*pi*f*t);

% Simulate response
spike_counts = zeros(size(hand));
for i = 1:numel(hand)
    afferent = hand(i);
    x = afferent.x;
    y = afferent.y;
    r = sqrt((x-0).^2 + (y-0).^2);
    j = find(r == min(r));
    threshold = 0.1;
    spike_counts(i) = sum(sine_wave(j) > threshold);
end

% Plot results
figure;
subplot(3,1,1);
plot(sine_wave);
title('Stimulus');

subplot(3,1,2);
plot(spike_counts(2:3));
title('SA1, RA, PC');
ylabel('Spike count');

subplot(3,1,3);
bar(spike_counts);
title('All afferents');
xlabel('Afferent index');
ylabel('Spike count');
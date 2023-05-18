
standardStimulus = 3.5;

data = zeros(100,2);

for nTrial = 1:100

    comparisonStimulus = randi([1 6]);

    if abs(comparisonStimulus - standardStimulus) < 1
        answer = 1;
    else
        answer = 0;
    end
    
    data(nTrial,:)=[comparisonStimulus answer];

end
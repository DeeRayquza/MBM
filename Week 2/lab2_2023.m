%lab2 - Implementation of grid sampling Bayesian Inference
%   Used in MBM 2022/2023 to demonstrate scripting for workshop 2
%   Will be distributed through Canvas
%   Students will rename the script, adding their ID to the name
%
%   Description:
%       Bayesian Brain Hypothesis
%
%   Other m-files required: none
%   MAT-files required: none
%

%   Author: Darshan Gohil
%   email: dxg288@student.bham.ac.uk
%   Date: 20/02/2023
%
%   Last revision: 20/02/2023, Author, Changes
%   21/02/2023 Darshan updated graphs

stdLikelihood= 1;
stdPrior=2;

samples=-20:0.01:20;
% normal distribution is specified at the points in samples with mean u and standard deviation sigma (σ)
% here mean u is 2 and standard deviation σ is stdLikelihood
likelihood=normpdf(samples,2,stdLikelihood);
likelihood=likelihood/sum(likelihood);
prior=normpdf(samples,0,stdPrior).^.5;
prior=prior/sum(prior);
posterior=likelihood.*prior;
posterior=posterior/sum(posterior);


%%plotting here
clf
plot(samples,likelihood,'r')
hold on
plot(samples,prior,'b')
plot(samples,posterior,'g')
title('Likelihood SD 3')
legend({'likelihood','prior','posterior'})
xlabel('velocity')
ylabel('probability')

%calculation of mean posterior
meanPosterior=sum(posterior.*samples);
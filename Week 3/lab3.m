%lab3 - Implementation of grid sampling Multisensory Integration
%   Used in MBM 2022/2023 to demonstrate scripting for workshop 3
%   Will be distributed through Canvas
%   Students will rename the script, adding their ID to the name
%
%   Description:
%       lab3
%
%   Other m-files required: none
%   MAT-files required: none
%

%   Author: Max Di Luca
%   email: m.diluca@bham.ac.uk
%   Date: 22/02/2023
%
%   Last revision: $date, Author, Changes

%% Remember to add your comments

clear all
clc
clf

%% Univariate case

angles=-180:1:180;


%% Put the values specified in the lab
% Initializing the reliability and direction values for the audio and
% visual stimuli
reliabilityAudio=0.05;
directionAudio=-60;

reliabilityVision=0.05;
directionVision=60;

% Calculating the standard deviation of the Gaussian distribution for the
% auditory signal using the given reliability value 
sigmaAudio=sqrt(1/reliabilityAudio);
likelihoodAudio=normpdf(angles,directionAudio,sigmaAudio);
% Likelihood values are normalized to ensure they integrate to 1
likelihoodAudio=likelihoodAudio/sum(likelihoodAudio);

% Calculating the same with respect to the visual signal and normaling it
sigmaVision=sqrt(1/reliabilityVision);
likelihoodVision=normpdf(angles,directionVision,sigmaVision);
likelihoodVision=likelihoodVision/sum(likelihoodVision);

%%
% Calculating the posterior distribution by multiplying the audio and
% visual liklihood functions and normalizing it
posterior=likelihoodVision.*likelihoodAudio;
posterior=posterior/sum(posterior);


%%
% Plotting the liklihood functions for the audio and visual signals in red
% and blue  and the posterior distribution in green
figure(1)
clf
plot(angles,likelihoodAudio,'r')
hold on
plot(angles,likelihoodVision,'b')
plot(angles,posterior,'g')
legend({'Audio likelihood','Visual Liklihood','posterior'})
xlabel('Angles in degrees')
ylabel('Probability Density')
title('Multisensory Integration')

%%
% Calculating the mean of both likelihood functions and the posterior
% distribution
meanLikelihoodAudio=sum(likelihoodAudio.*angles);
meanLikelihoodVision=sum(likelihoodVision.*angles);
meanPosterior=sum(posterior.*angles);

% Calculating the variance of both likelihood functions and the posterior
% distribution
variancelikelihoodAudio=sum(likelihoodAudio.*(angles-meanLikelihoodAudio).^2)
variancelikelihoodVision=sum(likelihoodVision.*(angles-meanLikelihoodVision).^2)
variancePosterior=sum(posterior.*(angles-meanPosterior).^2)

% Determining the values of the mean and reliability correspond to what we can predict analytically from MLE
meanPosteriorPred=(meanLikelihoodAudio+meanLikelihoodVision) / (reliabilityAudio+reliabilityVision)
variancePosteriorPred=1/(reliabilityAudio+reliabilityVision)

%% Bivariate case
% Initializing a 2-dimensional grid mesh ranging from -180 to 180 degrees
[angles_a,angles_v]=meshgrid(-180:1:180, -180:1:180);


%% Put the correct values here
% Initializing the values of w and sigma_p
w=0.0001;
sigma_p=1;


%%
% Generating a 2D image of the prior where the x-axis corresponds to visual angles and the y-axis corresponds to auditory angles. The color of each pixel indicates the probability density of the corresponding pair of angles.
prior = w+exp( - 1/4 * (angles_a.^2 - 2*angles_a.*angles_v + angles_v.^2) /sigma_p^2) ;
prior=prior/sum(sum(prior));

% Display the prior
figure(1)
clf
imagesc(prior)
axis equal tight
colorbar
title('Prior')
xlabel('Visual angle (degrees)')
ylabel('Auditory angle (degrees)')

%%
% Estimating the bivariate likelihood distributions
bivariateLikelihood=exp( - 1/2 *((angles_a-directionAudio).^2/sigmaAudio^2 +...
 (angles_v-directionVision).^2/sigmaVision^2 )) ;
bivariateLikelihood=bivariateLikelihood/sum(sum(bivariateLikelihood));


%%

posteriorBivariate=prior.*bivariateLikelihood;
posteriorBivariate=posteriorBivariate/sum(sum(posteriorBivariate));



%% plotting the three distributions as done in class
% Plotting the distributions of bivariate likelihood

figure(2)
clf
graphMultiplier=10000;


subplot(1,3,1)
surface(angles_a,angles_v,bivariateLikelihood*graphMultiplier)
shading interp 
colormap gray
axis equal tight 

subplot(1,3,2)
surface(angles_a,angles_v,prior*graphMultiplier)
shading interp 
colormap gray
axis equal tight 


subplot(1,3,3)
surface(angles_a,angles_v,posteriorBivariate*graphMultiplier)
shading interp 
colormap gray
axis equal tight 


% Plotting the posterior bivariate for the two cases
figure(3)
clf
imagesc(posteriorBivariate-bivariateLikelihood)
axis equal tight
colormap gray
title('-60 and +60 case')
xlabel('Visual angle (degrees)')
ylabel('Auditory angle (degrees)')
function dogFilters()
    % Load the image
    image = mat2gray(imread('tiger.png'));
    
    % Apply Difference of Gaussian filters with specified sigmas
    applyDoGFilter(image, 1, 3);
    applyDoGFilter(image, 3, 9);
    applyDoGFilter(image, 10, 30);
end

function applyDoGFilter(image, sigmaPositive, sigmaNegative)
    % Create the positive and negative Gaussians
    filterSize = 6 * sigmaPositive; % Adjust the size of the filter
    s = filterSize;
    x = -(s-1)/2:(s-1)/2;
    y = -(s-1)/2:(s-1)/2;
    [X, Y] = meshgrid(x, y);
    
    % Compute the positive and negative Gaussian filters
    GPositive = exp(-(X.^2 + Y.^2) / (2 * sigmaPositive^2)) / (sigmaPositive^2);
    GNegative = exp(-(X.^2 + Y.^2) / (2 * sigmaNegative^2)) / (sigmaNegative^2);
    
    % Create the Difference of Gaussian filter
    DoG = GPositive - GNegative;
    
    % Apply the DoG filter using conv2
    filtered_image = conv2(image, DoG, 'same');
    
    % Display the filtered image
    figure;
    subplot(1, 2, 1);
    imshow(image);
    title('Original Image');
    subplot(1, 2, 2);
    imshow(filtered_image);
    title('Filtered Image (DoG)');
end

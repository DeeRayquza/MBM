function gaussianfilter(sigma, filterSize)
    % Load the image
    image = mat2gray(imread('face.png'));

    % Create the Gaussian filter
    s = filterSize;
    x = -(s-1)/2:(s-1)/2;
    y = -(s-1)/2:(s-1)/2;
    [X, Y] = meshgrid(x, y);
    G = exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / (2 * pi * sigma^2);

    % Apply the Gaussian filter using conv2
    filtered_image = conv2(image, G, 'same');

    % Display the filtered image
    imshow(filtered_image);
    
    % Save the filtered image
    imwrite(uint8(mat2gray(filtered_image) .* 255), 'filtered_image.png', 'png');
end

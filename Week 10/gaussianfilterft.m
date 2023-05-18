function gaussianfilterft(sigma, filterSize)
    % Load the image
    image = mat2gray(imread('face.png'));

    % Create the Gaussian filter
    s = filterSize;
    x = -(s-1)/2:(s-1)/2;
    y = -(s-1)/2:(s-1)/2;
    [X, Y] = meshgrid(x, y);
    G = exp(-(X.^2 + Y.^2) / (2 * sigma^2)) / (2 * pi * sigma^2);

    % Transform image and filter to the Fourier domain
    image_fft = fft2(image);
    filter_fft = fft2(G, size(image, 1), size(image, 2));

    % Multiply the Fourier images element-wise
    filtered_fft = image_fft .* filter_fft;

    % Transform back to the spatial domain
    filtered_image = ifft2(filtered_fft);

    % Correct the filtered image
    filtered_image = ifftshift(filtered_image);

    % Display the filtered image
    imshow(filtered_image);

    % Save the filtered image
    imwrite(uint8(mat2gray(filtered_image) .* 255), 'filtered_image.png', 'png');
end

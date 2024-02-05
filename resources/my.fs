#version 330 core
out vec4 FragColor;

// Uniform for setting the color
uniform vec4 uColor;

void main() {
    // Set the output color of the pixel
    // FragColor = uColor;
    FragColor = vec4(1.0, 1.0, 1.0, 0.5); // RGBA

}

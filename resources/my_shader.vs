#version 330 core
layout (location = 0) in vec3 aPosition; // Vertex position

// Output to the fragment shader
out vec4 vertexColor;

// Uniforms
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main() {
    gl_Position = projection * view * model * vec4(aPosition, 1.0);
}

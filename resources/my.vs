#version 330 core
layout (location = 0) in vec3 aPosition; // Vertex positions
layout (location = 1) in vec2 aTexCoord; // Vertex texture coords (unused here but included for completeness)
layout (location = 2) in vec3 aNormal;   // Vertex normals (unused here but included for completeness)

// Uniforms for transforming the vertices
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

void main() {
    // Transform the vertex positions into clip space
    gl_Position = projection * view * model * vec4(aPosition, 1.0);
}
#version 330 core



layout (location = 0) in vec3 aPos; // The position variable has been given attribute position 0
out vec3 vertexColor; // Pass the vertex color to the fragment shader

// Uniforms for model, view, and projection matrices
uniform mat4 model;
uniform mat4 projection;
uniform mat4 view;

void main() {
    // Transform the vertex position from model space to clip space
    gl_Position = projection * view * model * vec4(aPos, 1.0);

    // Example of setting vertex color based on position; modify as needed
    vertexColor = vec3(0, 1, 0);
    //vertexColor = vec3(aPos.x, aPos.y, 1);
}

#version 330 core

in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;

in mat4 instanceTransform;

// Uniforms for model, view, and projection matrices
uniform mat4 mvp;
uniform mat4 matNormal;


// layout (location = 0) in vec3 aPos; // The position variable has been given attribute position 0
// out vec3 vertexColor; // Pass the vertex color to the fragment shader


void main() {
    // Transform the vertex position from model space to clip space
    mat4 mvpi = mvp * instanceTransform;
    gl_Position = mvpi*vec4(vertexPosition, 1.0);
    // gl_Position = mvpi * vec4(vertexPosition, 1.0);
    
    // gl_Position = projection * view * instance * vec4(vertexPosition, 1.0);
    //vec4(aPos, 1.0);

    // Example of setting vertex color based on position; modify as needed
    // vertexColor = vec3(0, 1, 0);
    //vertexColor = vec3(aPos.x, aPos.y, 1);
}
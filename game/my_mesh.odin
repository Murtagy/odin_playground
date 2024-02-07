package example
import rl "vendor:raylib"
import "core:math"
import "core:fmt"
import "core:math/linalg"



//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
main :: proc() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screenWidth :i32= 1024;
    screenHeight :i32= 800;

    rl.InitWindow(screenWidth, screenHeight, "raylib [models] example - waving cubes");

    // Initialize the camera
    camera := rl.Camera3D{
        rl.Vector3{30.0, 20.0, 30.0 },    // Camera position
        rl.Vector3{ 0.0, 0.0, 0.0 },      // Camera looking at point
        rl.Vector3{ 0.0, 1.0, 0.0 },      // Camera up vector (rotation towards target)
        70.0,                             // Camera field-of-view Y
        rl.CameraProjection.PERSPECTIVE
    }

    rl.SetTargetFPS(60);


    M :: 2
    model_matrices : = make([^]rl.Matrix, M)
    model_matrices[0] = linalg.Matrix4x4f32{
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            }
    model_matrices[1] = linalg.Matrix4x4f32{
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                5, 0, 0, 1
            }
    fmt.println(model_matrices[0])
    fmt.println(model_matrices[1])


    mesh := rl.GenMeshCube(1.0, 1.0, 1.0);
    model := rl.LoadModelFromMesh(mesh);

    shader := rl.LoadShader("resources/vs.glsl", "resources/fs.glsl")
    mvpLocation := rl.GetShaderLocation(shader, "model")
    // fragmentColorLocation := rl.GetShaderLocation(shader, "vertexColor")

    shader.locs[rl.ShaderLocationIndex.MATRIX_MVP] = rl.GetShaderLocation(shader, "mvp");
    shader.locs[rl.ShaderLocationIndex.VECTOR_VIEW] = rl.GetShaderLocation(shader, "viewPos");
    shader.locs[rl.ShaderLocationIndex.MATRIX_MODEL] = rl.GetShaderLocationAttrib(shader, "instanceTransform");


    // Update shader with MVP matrix and fragment color
    rl.SetShaderValueMatrix(shader, cast(rl.ShaderLocationIndex) rl.GetShaderLocation(shader, "model"),
        rl.Matrix{
        1, 0, 0, 0, 
        0, 1, 0, 0, 
        0, 0, 1, 0, 
        0, 0, 0, 1}
    )

    model.transform = linalg.MATRIX4F32_IDENTITY
    model.materials[0].shader = shader

    for !rl.WindowShouldClose() { 

        rl.UpdateCamera(&camera, rl.CameraMode.FREE);
        camera_pos := camera.position
        rl.SetShaderValue(shader, cast(rl.ShaderLocationIndex) rl.GetShaderLocation(shader, "viewPos"), &camera_pos, rl.ShaderUniformDataType.VEC3);

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.RAYWHITE);
        rl.DrawFPS(10, 10);

        {
            rl.BeginMode3D(camera);
            defer rl.EndMode3D();

            rl.DrawGrid(10, 5.0);
            rl.DrawMeshInstanced(model.meshes[0], model.materials[0], model_matrices, M);
            // rl.DrawMesh(model.meshes[0], model.materials[0], linalg.Matrix4x4f32{
            //     1, 0, 0, 0,
            //     0, 1, 0, 0,
            //     0, 0, 1, 0,
            //     1, 1, 1, 1
            // })
        }

    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    rl.CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

}
package example
import rl "vendor:raylib"
import "core:math"
import "core:fmt"



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

    mouse_ray : rl.Ray;
    cubePos := rl.Vector3{
        0.0, 0.0, 0.0
    }
    Vector3 :: [3]f32
    cubeSize :: Vector3{5.5, 5.5, 5.5};

    rl.SetTargetFPS(60);

    mesh := rl.GenMeshCube(1.0, 1.0, 1.0);
    model := rl.LoadModelFromMesh(mesh);

    for !rl.WindowShouldClose() { 
        mouse_pos := rl.GetMousePosition();
        mouse_ray = rl.GetMouseRay(mouse_pos, camera);

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.RAYWHITE);
        rl.DrawFPS(10, 10);


        {
            rl.BeginMode3D(camera);
            defer rl.EndMode3D();

            rl.DrawGrid(10, 5.0);
            // rl.DrawCube(cubePos, cubeSize.x, cubeSize.y, cubeSize.z, rl.BLUE);
            for i := 0; i < 100; i+=1 {
                for j := 0; j < 100; j+=1 {
                    // rl.DrawCube(rl.Vector3{f32(i), 0, f32(j)}, 1.0, 1.0, 1.0, rl.BLUE);
                    rl.DrawModel(model, rl.Vector3{f32(i), 0, f32(j)}, 1.0, rl.BLACK);
                }
            }
        }
            // rl.DrawModel(model, cubePos, 1.0, rl.WHITE);

    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    rl.CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

}
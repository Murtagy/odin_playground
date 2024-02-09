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
    cube_selected : bool;
    cube_drag : bool;
    // cube_collision : rl.RayCollision     // Ray collision hit info
    cubePos := rl.Vector3{
        0.0, 0.0, 0.0
    }
    Vector3 :: [3]f32
    cubeSize :: Vector3{5.5, 5.5, 5.5};

    rl.SetTargetFPS(60);

    direction := 0
    for !rl.WindowShouldClose() { 
        mouse_pos := rl.GetMousePosition();
        mouse_ray = rl.GetMouseRay(mouse_pos, camera);
        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            cube_box :=  rl.BoundingBox{
                { cubePos.x - cubeSize.x/2, cubePos.y - cubeSize.y/2, cubePos.z - cubeSize.z/2 },
                { cubePos.x + cubeSize.x/2, cubePos.y + cubeSize.y/2, cubePos.z + cubeSize.z/2 }
            }
            cube_collision := rl.GetRayCollisionBox(mouse_ray, cube_box)
            if cube_collision.hit {
                if cube_selected {
                    cube_drag = true;
                }
                cube_selected = true;
            } else {
                cube_selected = false;
                cube_drag = false;
            }
        } 
        if cube_drag && rl.IsMouseButtonReleased(rl.MouseButton.LEFT) {
            cube_drag = false;
        }
        if cube_drag {
            // update position of the cube based on the intersection point of the ray and the plane
            plane_collision := rl.GetRayCollisionBox(mouse_ray, rl.BoundingBox{
                { -30, 0, -30 },
                { 30, 0, 30 }
            })
            cubePos = plane_collision.point;
        }



        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.RAYWHITE);
        rl.DrawFPS(10, 10);

        // // move camera first X 30 -> -30, then Y 20.0 -> -20 (in "circle" around the grid)
        // if direction == 0 {camera.position.x -= 1; if camera.position.x == -30 {direction = 1}}
        // else if direction == 1 {camera.position.z -= 1; if camera.position.z == -20 {direction = 2}}
        // else if direction == 2 {camera.position.x += 1; if camera.position.x == 30 {direction = 3}}
        // else if direction == 3 {camera.position.z += 1; if camera.position.z == 20 {direction = 0}}


        rl.BeginMode3D(camera);
        defer rl.EndMode3D();

        rl.DrawGrid(10, 5.0);
        rl.DrawCube(cubePos, cubeSize.x, cubeSize.y, cubeSize.z, rl.BLUE);
        if cube_selected {
            rl.DrawCubeWires(cubePos, cubeSize.x, cubeSize.y, cubeSize.z, rl.MAROON);
            rl.DrawCubeWires(cubePos, cubeSize.x + 0.2, cubeSize.y + 0.2, cubeSize.z + 0.2, rl.GREEN);
        }
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    rl.CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

}
package example
import rl "vendor:raylib"
import "core:math"  // Required for: sinf()



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
        rl.Vector3{30.0, 20.0, 30.0 }, // Camera position
        rl.Vector3{ 0.0, 0.0, 0.0 },      // Camera looking at point
        rl.Vector3{ 0.0, 1.0, 0.0 },          // Camera up vector (rotation towards target)
        70.0,                                // Camera field-of-view Y
        rl.CameraProjection.PERSPECTIVE
    }

    // Specify the amount of blocks in each direction
    numBlocks := 15;

    rl.SetTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.WindowShouldClose()    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        time := rl.GetTime();

        // Calculate time scale for cube position and size
        scale := (2.0 + math.sin(time)) *0.7;

        // Move camera around the scene
        cameraTime := time*0.3;
        camera.position.x = f32(math.cos(cameraTime)*40.0)
        camera.position.z = f32(math.sin(cameraTime)*40.0)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.BeginDrawing();

            rl.ClearBackground(rl.RAYWHITE);

            rl.BeginMode3D(camera);

                rl.DrawGrid(10, 5.0);

                for x := 0; x < numBlocks; x+=1
                {
                    for y := 0; y < numBlocks; y+=1
                    {
                        for z := 0; z < numBlocks; z+=1
                        {
                            // Scale of the blocks depends on x/y/z positions
                            blockScale := (x + y + z)/30.0;

                            // Scatter makes the waving effect by adding blockScale over time
                            scatter := math.sin(f64(blockScale)*20.0 + (time*4.0));

                            // Calculate the cube position
                            cubePos := rl.Vector3{
                                f32((x - numBlocks))*f32(scale*3.0) + f32(scatter),
                                f32((y - numBlocks))*f32(scale*2.0) + f32(scatter),
                                f32((z - numBlocks))*f32(scale*3.0) + f32(scatter)
                            }

                            // Pick a color with a hue depending on cube position for the rainbow color effect
                            cubeColor := rl.ColorFromHSV(f32(((x + y + z)*18)%360), 0.75, 0.9);

                            // Calculate cube size
                            cubeSize := (2.4 - scale)*f64(blockScale);

                            // And finally, draw the cube!
                            rl.DrawCube(cubePos, f32(cubeSize), f32(cubeSize), f32(cubeSize), cubeColor);
                        }
                    }
                }

            rl.EndMode3D();

            rl.DrawFPS(10, 10);

        rl.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    rl.CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

}
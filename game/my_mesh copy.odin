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

    mesh := rl.GenMeshCube(1.0, 1.0, 1.0);

    // rl.UploadMesh(&mesh, false); // Upload vertex data to GPU (static mesh
    model := rl.LoadModelFromMesh(mesh);

    // // model_matrices : [100000]rl.Matrix;
    // fmt
    M :: 2
    // M :: 1
    model_matrices : = make([^]rl.Matrix, M)

    // model_matrices[0] = linalg.MATRIX4F32_IDENTITY * linalg.matrix4_translate_f32({0, 0, 0})
    // for i := 0; i < 1000; i+=1 {
    //     for j := 0; j < 100; j+=1 {
    //         // m := rl.Matrix{
    //         // 1, 0, 0, f32(i * 2),
    //         // 0, 1, 0, 0,
    //         // 0, 0, 1, f32(j * 2),
    //         // 0, 0, 0, 1
    //         // };
    //         // fmt.println(m)
    //         model_matrices[i * 100 + j] = (linalg.matrix4_translate_f32({f32(i*2), f32(0), f32(j*3)}) * (linalg.matrix4_rotate_f32(0, {1, 1, 1}) * (linalg.matrix4_scale_f32({1, 1, 1})  * linalg.MATRIX4F32_IDENTITY)));
    //     }
    // }
    // model_matrices[0] = linalg.Matrix4x4f32{
    //             1, 0, 0, 0,
    //             0, 1, 0, 0,
    //             0, 0, 1, 0,
    //             1, 1, 1, 1
    //         }

    model_matrices[0] = linalg.Matrix4x4f32{
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                10, 1, 1, 1
            }
    model_matrices[1] = linalg.Matrix4x4f32{
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                10, 1, 1, 1
            }
    fmt.println(model_matrices[0])
    fmt.println(model_matrices[1])


    // // Load shaders
    // sshader := rl.LoadShader("resources/asteroids_instanced.fs", "resources/asteroids_intanced.vs")
    // sshader.locs[rl.ShaderLocationIndex.MATRIX_MVP] = rl.GetShaderLocation(sshader, "mvp")
    // sshader.locs[rl.ShaderLocationIndex.MATRIX_MODEL] = rl.GetShaderLocation(sshader, "instance")
    // sshader.locs[rl.ShaderLocationIndex.MATRIX_VIEW] = rl.GetShaderLocation(sshader, "view")
    // sshader.locs[rl.ShaderLocationIndex.MATRIX_PROJECTION] = rl.GetShaderLocation(sshader, "projection")

    shader := rl.LoadShader("resources/vs.glsl", "resources/fs.glsl")
    // uColorLoc := rl.GetShaderLocation(shader, "uColor")     // Get uniform location for the color in the fragment shader
    // color := [4]f32{1.0, 0.0, 0.0, 1.0} // RGBA
    // rl.SetShaderValue(shader, cast(rl.ShaderLocationIndex)uColorLoc, &color, rl.ShaderUniformDataType.VEC4)
    // material := rl.LoadMaterialDefault()
    // material.shader = shader

    // shader := rl.LoadShader("resources/vs.glsl", "resources/fs.glsl")
    mvpLocation := rl.GetShaderLocation(shader, "model")
    fragmentColorLocation := rl.GetShaderLocation(shader, "vertexColor")

    shader.locs[rl.ShaderLocationIndex.MATRIX_MODEL] = rl.GetShaderLocation(shader, "model")
    shader.locs[rl.ShaderLocationIndex.MATRIX_VIEW] = rl.GetShaderLocation(shader, "view")
    shader.locs[rl.ShaderLocationIndex.MATRIX_PROJECTION] = rl.GetShaderLocation(shader, "projection")

    mvpMatrix := rl.Matrix{
    1, 0, 0, 0, 
    0, 1, 0, 0, 
    0, 0, 1, 0, 
    10, 0, 0, 1}
    // colorValue := rl.Color{1.0, 0.0, 0.0, 1.0} // Red color

    // // Update shader with MVP matrix and fragment color
    rl.SetShaderValueMatrix(shader, cast(rl.ShaderLocationIndex)  mvpLocation, mvpMatrix)
    // rl.SetShaderValue(shader, cast(rl.ShaderLocationIndex)  fragmentColorLocation, &colorValue[0], rl.ShaderUniformDataType.VEC4)

    // material := rl.LoadMaterialDefault()
    // material.shader = shader
    model.transform = linalg.MATRIX4F32_IDENTITY
    model.materials[0].shader = shader

    // material.maps[0].color = rl.GRAY; // Set material color to red

    // material2 := rl.LoadMaterialDefault()
    // material2.shader = sshader
    // material.maps[0].color = rl.GRAY; // Set material color to red


    // fmt.println(shader)
    // fmt.println(material)
    // fmt.println(mesh)
    // fmt.println(linalg.matrix4_translate_f32({1, 1, 1}) * linalg.MATRIX4F32_IDENTITY)

    for !rl.WindowShouldClose() { 

        rl.UpdateCamera(&camera, rl.CameraMode.FREE);

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.RAYWHITE);
        rl.DrawFPS(10, 10);


        // blending := rl.BlendMode.ALPHA
        {
            rl.BeginMode3D(camera);
            defer rl.EndMode3D();
            // rl.BeginBlendMode(blending)
            // defer rl.EndBlendMode() 
            // rl.EnableRenderState(rl.BLEND)

            rl.DrawGrid(10, 5.0);

            // rl.DrawMesh(mesh, material, linalg.MATRIX4F32_IDENTITY)
            // rl.DrawMesh(mesh, material, model_matrices[0]);
            // fmt.println("1")
            // fmt.println(model_matrices[0])
            // fmt.println("2")
            // fmt.println(model_matrices[1])
            // fmt.println("3")
            // fmt.println(model_matrices[2])

            // rl.DrawMesh(mesh, material, model_matrices[0]);

            // rl.BeginShaderMode(shader)
            // rl.DrawMesh(mesh, material, model_matrices[0]);
            // rl.DrawMeshInstanced(mesh, material, model_matrices, M);
            rl.DrawMeshInstanced(model.meshes[0], model.materials[0], model_matrices, M);
            // defer rl.EndShaderMode()
        // rl.DrawModel(model, rl.Vector3{f32(i * 2), 0, f32(j * 2)}, 1.0, rl.BLACK);

            // rl.DrawMesh(mesh, material, linalg.MATRIX4F32_IDENTITY * linalg.matrix4_translate_f32({5, 1, 1})) * {0, 0, 0} // * linalg.matrix4_rotate_f32(0, {1, 1, 1}) * linalg.matrix4_scale_f32({1, 1, 1}))
            // rl.DrawMesh(model.meshes[0], model.materials[0], linalg.Matrix4x4f32{
            //     1, 0, 0, 0,
            //     0, 1, 0, 0,
            //     0, 0, 1, 0,
            //     5, 1, 1, 1
            // })

            // for i := 0; i < M; i+=1 {
                    // rl.DrawCube(rl.Vector3{f32(i), 0, f32(j)}, 1.0, 1.0, 1.0, rl.BLUE);
                    // rl.DrawModel(model, rl.Vector3{f32(i * 2), 0, f32(j * 2)}, 1.0, rl.BLACK);
                    // rl.DrawMesh(mesh, material, model_matrices[i])
                    // rl.DrawMesh(mesh, material, model_matrices[i * 100 + j] )
                    // cubePos := rl.Vector3{0.0, 0.0, 0.0} // Change this to a position within the camera's view
                    // rl.DrawCube(cubePos, 1.0, 1.0, 1.0, material.maps[0].color)
                    // fmt.println(model_matrices[i * 100 + j])
            // }


            // rl.DrawMesh(mesh, material, linalg.MATRIX4F32_IDENTITY)
            // rl.DrawMesh(mesh, material, model_matrices[0]);
            // rl.DrawMesh(mesh, material, model_matrices[1]);
            // rl.DrawMesh(mesh, material, model_matrices[1000]);
            // rl.DrawMesh(mesh, material, model_matrices[10000]);
            // rl.DrawMeshInstanced(mesh, material, model_matrices, M);

            // fmt.println(linalg.MATRIX4F32_IDENTITY)
            // {
            //     // model.materials[0].shader.id = rl.GetShaderIdDefault();
            //     for i := 0; i < 1000; i+=1
            //     {
            //         model.transform = linalg.MATRIX4F32_IDENTITY * linalg.matrix4_translate_f32({f32(i*2), f32(0), f32(0)})
            //         rl.DrawModel(model, {0,0,0}, 1.0, rl.RED);
            //     }
            // }
            // rl.EndShaderMode()
            // rl.DrawMesh(mesh, material2, linalg.MATRIX4F32_IDENTITY)
        }
            // rl.DrawModel(model, cubePos, 1.0, rl.WHITE);

    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    rl.CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

}
package example

import rl "vendor:raylib"
import "core:math/rand"
import "core:fmt"


W :: 1440;
H :: 1024;



pixels: [1000] rl.Vector2;


main :: proc() {
    for p, i in pixels {
        pixels[i] = {W * rand.float32(), H * rand.float32()}
    }

    rl.InitWindow(W, H, "raylib [core] example - basic window")
    defer rl.CloseWindow()

    // rl.SetTargetFPS(60)
    x := 0;
    dir := 1;

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()

        rl.ClearBackground(rl.RAYWHITE)
        rl.DrawFPS(600, 0)

        // rl.DrawText("Congrats! You created your first window!", 190, 200, 20, rl.LIGHTGRAY)
        // rl.DrawRectangle(i32(x), 1, 40, 40, rl.RED)
        x += 1 * dir;
        if x == W - 40 { dir = -1}
        if x == 0 { dir = 1}

        for p, i in pixels {
             rl.DrawRectangle(i32(p.x), i32(p.y), 2, 2, rl.BLUE)
            // rl.DrawPixel(i32(p.x), i32(p.y), rl.BLUE)
            // rl.DrawCircle(i32(p.x), i32(p.y), 5, rl.BLUE)
            pixels[i].x += 1
            pixels[i].y += 1
            nx := p.x + 1
            ny := p.y + 1
            if nx > W  {
                nx = 0
            }
            if ny > H {
                ny = 0
            }
            pixels[i].x = nx;
            pixels[i].y = ny;
        }
    }
}
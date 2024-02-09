package main

import "core:fmt"
import "core:math/rand"

import raylib "vendor:raylib"

MAX_PARTICLES :: 200

Particle :: struct {
    position: raylib.Vector2,
    color: raylib.Color,
    alpha: f32,
    size: f32,
    rotation: f32,
    active: bool,
}

main :: proc() {
    screenWidth := i32(800)
    screenHeight := i32(450)

    raylib.InitWindow(screenWidth, screenHeight, "raylib [textures] example - particles blending")
    defer raylib.CloseWindow()

    mouseTail: [MAX_PARTICLES]Particle

    for i in 0..<MAX_PARTICLES {
        mouseTail[i].position = raylib.Vector2{0, 0}
        mouseTail[i].color = raylib.Color{u8(rand.int31_max(255)), u8(rand.int31_max(255)), u8(rand.int31_max(255)), 255}
        mouseTail[i].alpha = 1.0
        mouseTail[i].size = f32(rand.int31_max(30))/20.0
        mouseTail[i].rotation = f32(rand.int31_max(360))
        mouseTail[i].active = false
    }

    gravity := f32(3.0)

    smoke := raylib.LoadTexture("resources/spark_flame.png")
    defer raylib.UnloadTexture(smoke)

    blending := raylib.BlendMode.ALPHA

    raylib.SetTargetFPS(60)

    for !raylib.WindowShouldClose() {
        for i in 0..<MAX_PARTICLES {
            if !mouseTail[i].active {
                mouseTail[i].active = true
                mouseTail[i].alpha = 1.0
                mouseTail[i].position = raylib.GetMousePosition()
                break
            }
        }

        for i in 0..<MAX_PARTICLES {
            if mouseTail[i].active {
                mouseTail[i].position.y += gravity/2
                mouseTail[i].alpha -= 0.005

                if mouseTail[i].alpha <= 0.0 {
                    mouseTail[i].active = false
                }

                mouseTail[i].rotation += 2.0
            }
        }

        if raylib.IsKeyPressed(raylib.KeyboardKey.SPACE) {
            if blending == raylib.BlendMode.ALPHA {
                blending = raylib.BlendMode.ADDITIVE
            } else {
                blending = raylib.BlendMode.ALPHA
            }
        }

        raylib.BeginDrawing()
        defer raylib.EndDrawing()
        raylib.ClearBackground(raylib.DARKGRAY)
        {
        raylib.BeginBlendMode(blending)
        defer raylib.EndBlendMode() 
        for i in 0..<MAX_PARTICLES {
            if mouseTail[i].active {
                source := raylib.Rectangle{0.0, 0.0, f32(smoke.width), f32(smoke.height)}
                dest := raylib.Rectangle{mouseTail[i].position.x, mouseTail[i].position.y, f32(smoke.width)*mouseTail[i].size, f32(smoke.height)*mouseTail[i].size}
                origin := raylib.Vector2{f32(smoke.width)*mouseTail[i].size/2.0, f32(smoke.height)*mouseTail[i].size/2.0}
                raylib.DrawTexturePro(smoke, source, dest, origin, mouseTail[i].rotation, raylib.Fade(mouseTail[i].color, mouseTail[i].alpha))
            }
        }

        }

        raylib.DrawText("PRESS SPACE to CHANGE BLENDING MODE", 180, 20, 20, raylib.BLACK)

        if blending == raylib.BlendMode.ALPHA {
            raylib.DrawText("ALPHA BLENDING", 290, screenHeight - 40, 20, raylib.BLACK)
        } else {
            raylib.DrawText("ADDITIVE BLENDING", 280, screenHeight - 40, 20, raylib.RAYWHITE)
        }

    }

}
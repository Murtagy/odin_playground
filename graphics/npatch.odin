package main

import "core:fmt"
import "core:math/rand"

import raylib "vendor:raylib"

main :: proc() {
    screenWidth := 800
    screenHeight := 450

    raylib.InitWindow(i32(screenWidth), i32(screenHeight), "raylib [textures] example - N-patch drawing")

    nPatchTexture := raylib.LoadTexture("resources/ninepatch_button.png")

    mousePosition := raylib.Vector2{0, 0}
    origin := raylib.Vector2{0.0, 0.0}

    dstRec1 := raylib.Rectangle{480.0, 160.0, 32.0, 32.0}
    dstRec2 := raylib.Rectangle{160.0, 160.0, 32.0, 32.0}
    dstRecH := raylib.Rectangle{160.0, 93.0, 32.0, 32.0}
    dstRecV := raylib.Rectangle{92.0, 160.0, 32.0, 32.0}

    ninePatchInfo1 := raylib.NPatchInfo{(raylib.Rectangle){0.0, 0.0, 64.0, 64.0  }, 12, 40, 12, 12, raylib.NPatchLayout.NINE_PATCH}
    ninePatchInfo2 := raylib.NPatchInfo{(raylib.Rectangle){0.0, 128.0, 64.0, 64.0}, 16, 16, 16, 16, raylib.NPatchLayout.NINE_PATCH}
    h3PatchInfo    := raylib.NPatchInfo{(raylib.Rectangle){0.0, 64.0, 64.0, 64.0 }, 8, 8, 8, 8,     raylib.NPatchLayout.THREE_PATCH_HORIZONTAL}
    v3PatchInfo    := raylib.NPatchInfo{(raylib.Rectangle){0.0, 192.0, 64.0, 64.0}, 6, 6, 6, 6,     raylib.NPatchLayout.THREE_PATCH_VERTICAL}

    raylib.SetTargetFPS(60)

    for !raylib.WindowShouldClose() {
        mousePosition = raylib.GetMousePosition()

        dstRec1.width = mousePosition.x - dstRec1.x
        dstRec1.height = mousePosition.y - dstRec1.y
        dstRec2.width = mousePosition.x - dstRec2.x
        dstRec2.height = mousePosition.y - dstRec2.y
        dstRecH.width = mousePosition.x - dstRecH.x
        dstRecV.height = mousePosition.y - dstRecV.y

        if dstRec1.width < 1.0 { dstRec1.width = 1.0 }
        if dstRec1.width > 300.0 { dstRec1.width = 300.0 }
        if dstRec1.height < 1.0 { dstRec1.height = 1.0 }

        if dstRec2.width < 1.0 { dstRec2.width = 1.0 }
        if dstRec2.width > 300.0 { dstRec2.width = 300.0 }
        if dstRec2.height < 1.0 { dstRec2.height = 1.0 }

        if dstRecH.width < 1.0 { dstRecH.width = 1.0 }
        if dstRecV.height < 1.0 { dstRecV.height = 1.0 }

        raylib.BeginDrawing()

        raylib.ClearBackground(raylib.RAYWHITE)

        raylib.DrawTextureNPatch(nPatchTexture, ninePatchInfo2, dstRec2, origin, 0.0, raylib.WHITE)
        raylib.DrawTextureNPatch(nPatchTexture, ninePatchInfo1, dstRec1, origin, 0.0, raylib.WHITE)
        raylib.DrawTextureNPatch(nPatchTexture, h3PatchInfo, dstRecH, origin, 0.0, raylib.WHITE)
        raylib.DrawTextureNPatch(nPatchTexture, v3PatchInfo, dstRecV, origin, 0.0, raylib.WHITE)

        raylib.DrawRectangleLines(5, 88, 74, 266, raylib.BLUE)
        raylib.DrawTexture(nPatchTexture, 10, 93, raylib.WHITE)
        raylib.DrawText("TEXTURE", 15, 360, 10, raylib.DARKGRAY)

        raylib.DrawText("Move the mouse to stretch or shrink the n-patches", 10, 20, 20, raylib.DARKGRAY)

        raylib.EndDrawing()
    }

    raylib.UnloadTexture(nPatchTexture)
    raylib.CloseWindow()
}
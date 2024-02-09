package main

import "core:math"

main :: proc() {
    // Define a vector with two elements
     vector: [2]real32 = [1.0, 2.0]

    // Print the original vector
    println("Original Vector:", vector)

    // Update the first element of the vector
    vector[0] = 3.0

    // Update the second element of the vector
    vector[1] = 4.0

    // Print the updated vector
    println("Updated Vector:", vector)
}

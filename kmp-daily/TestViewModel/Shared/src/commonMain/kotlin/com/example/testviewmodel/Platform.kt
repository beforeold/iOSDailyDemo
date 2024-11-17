package com.example.testviewmodel

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform
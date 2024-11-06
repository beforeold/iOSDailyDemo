plugins {
    alias(libs.plugins.android.library) apply false
    alias(libs.plugins.kotlin.multiplatform) apply false
}

buildscript {
    repositories {
        gradlePluginPortal()
        mavenCentral()
        google()
    }

    dependencies {
        classpath(libs.atomicfu.gradle.plugin)
    }
}

allprojects {
    group = "com.rickclephas.kmp"
    version = "1.0.0-BETA-7"

    repositories {
        mavenCentral()
        google()
    }
}

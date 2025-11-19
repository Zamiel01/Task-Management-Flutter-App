// Root-level build.gradle.kts

plugins {
    // Do NOT add versions for Android plugins — Flutter handles them
    id("com.android.application") apply false
    id("com.android.library") apply false
    kotlin("android") apply false

  
    // Google services plugin — no version here
    id("com.google.gms.google-services") apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // No version here
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.todo"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.example.todo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))
    implementation("com.google.firebase:firebase-analytics")
    // Add other Firebase libraries here
}

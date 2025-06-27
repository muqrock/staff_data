allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // ... other dependencies
        classpath 'com.google.gms:google-services:4.4.1' // Check Firebase docs for latest version
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// In your app/build.gradle file
plugins {
    id 'com.android.application'
    // ... other plugins
    id 'com.google.gms.google-services' // Google Services plugin
}

dependencies {
    // ... other dependencies

    // Firebase platform dependency (BOM) - recommended for managing versions
    implementation platform('com.google.firebase:firebase-bom:32.7.0') // Check for latest version

    // Firebase Authentication
    implementation 'com.google.firebase:firebase-auth-ktx' // For Kotlin, use -ktx

    // Cloud Firestore
    implementation 'com.google.firebase:firebase-firestore-ktx' // For Kotlin, use -ktx

    // Firebase App Distribution (SDK for App Distribution is primarily for testers to use)
    // You might not need a direct SDK dependency for App Distribution in your app's code,
    // as it's more about releasing builds.
}

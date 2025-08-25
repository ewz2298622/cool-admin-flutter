plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
repositories {
    flatDir {
        dirs("./libs")
    }
    maven { url = uri("https://artifact.bytedance.com/repository/AwemeOpenSDK") }
}

//dependencies {
//    // Kotlin标准库
//
//    // 广点通 SDK和Adapter
//    implementation("com.gdt:sdk:4.563.1433@aar")
//    implementation("com.gdt:adapter:4.563.1433.0@aar")
//
//    // 百度SDK和Adapter
//    implementation("com.baidu:mobads:9.34@aar")
//    implementation("com.baidu:adapter:9.34.0@aar")
//
//    // 快手SDK和Adapter
//    implementation("com.kuaishou:sdk:3.3.59@aar")
//    implementation("com.kuaishou:adapter:3.3.59.0@aar")
//}

dependencies {
//implementation(fileTree(mapOf("dir" to "./libs", "include" to listOf("*.jar"), "exclude" to listOf("*open_ad_sdk*"))))

    // AAR 包依赖
//    implementation(":GDTSDK.unionNormal.4.563.1433@aar")
//    implementation(":kssdk-ad-3.3.59@aar")
//    implementation(":mediation_gdt_adapter_4.563.1433.0@aar")
//    implementation(":mediation_ks_adapter_3.3.59.0@aar")
    // 广告SDK相关依赖由 flutter_unionad 插件提供，避免与 app 侧重复引入导致冲突
}




flutter {
    source = "../.."
}

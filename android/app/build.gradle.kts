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
        
        // 添加多 dex 支持以减少主 dex 文件大小
        multiDexEnabled = true
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
            
            // 添加额外的优化配置
            isDebuggable = false
            isJniDebuggable = false
        }
        debug {
            // 启用调试模式下的资源压缩
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
    
    // 添加APK压缩配置
    packaging {
        resources {
            excludes += listOf(
                "META-INF/*.kotlin_module",
                "META-INF/LICENSE*",
                "META-INF/NOTICE*",
                "META-INF/AL2.0",
                "META-INF/LGPL2.1",
                "META-INF/DEPENDENCIES",
                "/*.txt",
                "/*.bin",
                // 添加更多排除项以减小 APK 体积
                "META-INF/README*",
                "META-INF/NOTICE*",
                "META-INF/INDEX.LIST",
                "META-INF/MANIFEST.MF",
                "META-INF/proguard/*",
                "/*.properties"
            )
        }
        jniLibs {
            useLegacyPackaging = true
        }
        dex {
            useLegacyPackaging = true
        }
    }
    
    // 启用R8编译器优化
    compileOptions {
        isCoreLibraryDesugaringEnabled = true
    }
    
    // 添加拆分配置以生成针对不同屏幕密度的 APK
    splits {
        density {
            isEnable = true
            reset()
            include("mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi")
        }
    }
}

repositories {
    flatDir {
        dirs("./libs")
    }
    maven { url = uri("https://artifact.bytedance.com/repository/AwemeOpenSDK") }
}

dependencies {
//implementation(fileTree(mapOf("dir" to "./libs", "include" to listOf("*.jar"), "exclude" to listOf("*open_ad_sdk*"))))

    // AAR 包依赖
//    implementation(":GDTSDK.unionNormal.4.563.1433@aar")
//    implementation(":kssdk-ad-3.3.59@aar")
//    implementation(":mediation_gdt_adapter_4.563.1433.0@aar")
//    implementation(":mediation_ks_adapter_3.3.59.0@aar")
    // 广告SDK相关依赖由 flutter_unionad 插件提供，避免与 app 侧重复引入导致冲突
    
    // 添加 coreLibraryDesugaring 依赖以解决编译错误
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.1.5")
    
    // 添加 multidex 支持
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}
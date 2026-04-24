# 运行Flutter项目到Android平台的说明

## 前提条件
1. 已安装Flutter SDK
2. 已安装Android Studio和Android SDK
3. 已配置环境变量（ANDROID_HOME, PATH等）
4. 已连接Android设备或创建了Android模拟器

## 运行步骤

### 1. 获取项目依赖
```bash
flutter pub get
```

### 2. 检查设备连接
```bash
flutter devices
```

### 3. 运行到Android设备
```bash
flutter run
```

### 4. 或者指定构建目标
```bash
# 运行到特定设备
flutter run -d <device_name>

# 构建APK
flutter build apk

# 构建AppBundle（用于发布到Google Play）
flutter build appbundle
```

## 常见问题解决

### 如果遇到"Android SDK not found"错误：
1. 确保已安装Android Studio
2. 在Android Studio中安装Android SDK
3. 设置ANDROID_HOME环境变量指向SDK路径

### 如果遇到"no devices found"：
1. 确保Android设备已开启USB调试
2. 或者启动Android模拟器
3. 检查设备是否被正确识别：`adb devices`

### 如果遇到构建错误：
```bash
# 清理项目
flutter clean
flutter pub get

# 重新构建
flutter run
```
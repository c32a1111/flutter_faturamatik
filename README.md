# flutter_faturamatik

### Requirements
- iOS 11 or later (13 for NFC Capture)
- Flutter 2.12.0 or later

### iOS requirements

Add these lines on your pod file
```ruby
source 'https://github.com/c32a1111/FaturamatikSDK.git'
source 'https://cdn.cocoapods.org/'
```

If not yet set the default iOS version to 13
```ruby
 platform :ios, '13.0'
 ```

### iOS permissions

You have to add these permissions into your `info.plist` file. All permissions are required for app submission according to your usage.

For Camera:

```xml
	<key>NSCameraUsageDescription</key>
	<string>This application requires access to your camera for scanning and uploading the document.</string>
```

### Adding the flutter plugin 
To add this flutter plugin you must add the lines below to your `pubspec.yaml` file.

```yaml
flutter_amanisdk_v2:
  git:
    url: https://github.com/c32a1111/flutter_faturamatik
    branch: main
```


## Usage
Modules uses the same pattern of containing `start`, `setType` and `upload` methods. Each `start` method can have different parameters.

This method needs to be called only **once** unless you have some other plugin that starts it's own activity.

## While Usage

After the integration is achieved, you may receive an error starting with "dyld[8460]: Library not loaded: /Library/Frameworks/" when running the application.

To fix this error, you need to run the following lines in the terminal, in the /example/ios file directory of your project.

1-
install_name_tool -id @rpath/FaturamatikVerify.framework/FaturamatikVerify\
Pods/FaturamatikVerify/FaturamatikVerify.xcframework/ios-arm64/FaturamatikVerify.framework/FaturamatikVerify

2-

install_name_tool -change /Library/Frameworks/FaturamatikVerify.framework/FaturamatikVerify\
@rpath/FaturamatikVerify.framework/FaturamatikVerify\
Pods/FaturamatikVerify/FaturamatikVerify.xcframework/ios-arm64/FaturamatikVerify.framework/FaturamatikVerify

3-

codesign --force --deep --sign - Pods/FaturamatikVerify/FaturamatikVerify.xcframework/ios-arm64/FaturamatikVerify.framework/FaturamatikVerify

4-

otool -L Pods/FaturamatikVerify/FaturamatikVerify.xcframework/ios-arm64/FaturamatikVerify.framework/FaturamatikVerify

### IDCapture module
Get the id capture module from the main `FaturamatikVerify` [instance which you have previously initialized.]

```dart
final FlutterFaturamatik _faturamatikSDK = FlutterFaturamatik();

// Since the platform plugins are async, you must create this function
Future<void> initIDModule() async {
    var idCapture = _faturamatikSDK.getIdCapture();
    await idCapture.setType("XXX_ID_0");
}

//And call it here.
@override
void initState() {
    super.initState();
    initIDModule();
}

```

Later on the buttons `onPressed` 
```dart
onPressed: () async {
            final Uint8List imageData =
                await _idCapture.getIDCapture().start(IdSide.front);
            // Do something with imageData
            setState(() {
                _imageData = imageData;
            });
          },
```

After getting the image data from the SDK, you can use it with `Image.memory()`.


#### Auto selfie usage
Get the auto selfie module from the main `AmaniSDK` [instance which you have previously initialized.]
```dart
final FlutterFaturamatik _faturamatikSDK = FlutterFaturamatik();

// Configure the AutoSelfie
final IOSAutoSelfieSettings _iOSAutoSelfieSettings = IOSAutoSelfieSettings(
      faceIsOk: "Please hold stable",
      notInArea: "Please align your face with the area",
      faceTooSmall: "Your face is in too far",
      faceTooBig: "Your face is in too close",
      completed: "All OK!",
      appBackgroundColor: "000000",
      appFontColor: "ffffff",
      primaryButtonBackgroundColor: "ffffff",
      ovalBorderSuccessColor: "00ff00",
      ovalBorderColor: "ffffff",
      countTimer: "3",
      manualCropTimeout: 30);

// Since the platform plugins are async, you must create this function
Future<void> initAutoSelfie() async {
    var selfie = _faturamatikSDK.getAutoSelfie();
    await selfie.setType("XXX_SE_0");
}

//And call it here.
@override
void initState() {
    super.initState();
    initAutoSelfie();
}
```

Later on the buttons `onPressed` 
```dart
onPressed: () async {
            final Uint8List imageData =
                await _faturamatikSDK().getAutoSelfie().start(
                    iosAutoSelfieSettings: _iOSAutoSelfieSettings,
                );
            // Do something with imageData
            setState(() {
                _imageData = imageData;
            });
          },
```


#### How to use Uint8List image data to render images.

Just use the `Image.memory(data)` to render image and set width, height and other properties that you can give to `Image` widget with it. For example:

```dart
Image.memory(
            imageData,
            fit: BoxFit.contain,
            width: double.infinity,
            height: 450,
          ),
```
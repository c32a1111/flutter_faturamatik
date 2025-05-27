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
For NFC:

```xml
	<key>NFC Scan Usage Description</key>
	<string>This application requires access to your nfc for scanning the document.</string>
```

For Capability: 
```xml
  Start before NFC process, you need to set capabilities.
  
	Xcode > Project Target > Signing & Capabilities > Near Field Communication Tag Reading 
```

For ISO7816 Identifiers: 
```xml
  Start before NFC process, you need to set those nfc identifiers to info.plist
  
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
    <string>A0000002471001</string>
    <string>E80704007F00070302</string>
    <string>A000000167455349474E</string>
    <string>A0000002480100</string>
    <string>A0000002480200</string>
    <string>A0000002480300</string>
    <string>A00000045645444C2D3031</string>
</array>
	
```

### Adding the flutter plugin 
To add this flutter plugin you must add the lines below to your `pubspec.yaml` file.

```yaml
flutter_faturamatik:
  git:
    url: https://github.com/c32a1111/flutter_faturamatik
    branch: main
```


## Usage
Modules uses the same pattern of containing `start`, `setType` and `upload` methods. Each `start` method can have different parameters.

This method needs to be called only **once** unless you have some other plugin that starts it's own activity.

## While Usage - With NFC
Before start IDCapture process you need to set "mrzInfoDelegate". This requires steps because you will follow up the User's mrz datas.
```dart
Future<void> initDelegates() async {
  FlutterFaturamatik().setDelegates().then((_) {

  });
    
    await for (final delegateEvent in FlutterFaturamatik().getDelegateStream()) {
      print("delegate event recievedDDDD");
      print(delegateEvent);
    }
  }

```

After the back identity is captured, we can call this function and trigger the delegate function we set above.
```dart

  Future<String?> startMrzRequest() async {
    final String? mrzDocId = await _idCapture.getMrzRequest();
    return mrzDocId;
  }

```

```dart
  if (Platform.isIOS) {
      await startMrzRequest();
      Map<String, dynamic> result = await startListeningForMrzResult(); //Here we're start the listening to delegate stream and start NFC process.

      if (result.isNotEmpty) {
        bool isDone = await _idCapture.iosStartNFC(result);
        if (isDone) {
          bool isSuccess = await _idCapture.upload();
          if (isSuccess) {
            Navigator.pushNamed(
              context,
              ConfirmScreenState.routeName,
              arguments: ConfirmArguments(
                source: "idCapture",
                imageData: args.imageData,
                idCaptureBothSidesTaken: true,
                idCaptureNFCCompleted: true,
              ),
            );
          }
        }
      } else {
        print("MRZ veya NFC datası eksik.");
      }
    }
                        
  ```

## IDCapture module
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


## Auto selfie usage
Get the auto selfie module from the main `FaturamatikSDK` [instance which you have previously initialized.]
```dart
final FlutterFaturamatik _faturamatikSDK = FlutterFaturamatik();

// Configure the AutoSelfie
final IOSAutoSelfieSettings _iOSAutoSelfieSettings = IOSAutoSelfieSettings(
      faceIsOk: "Please hold stable",
      notInArea: "Please align your face with the area",
      faceTooSmall: "Your face is in too far",
      faceTooBig: "Your face is in too close",
      completed: "Completed",
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

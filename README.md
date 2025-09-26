# PermissionKit

## Overview

PermissionKit is a lightweight and easy-to-use Swift library designed to simplify requesting and managing app permissions on iOS. It provides a unified interface to handle various system permissions such as Camera, Microphone, Location, Notifications, and more, making permission handling straightforward and consistent across your app.

## Installation

### Swift Package Manager

Add PermissionKit to your project by adding the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/vishalvaghasiya-ios/PermissionKit.git", from: "1.0.0")
]
```

Or, in Xcode, go to **File > Swift Packages > Add Package Dependency** and enter the repository URL.

## Usage

First, import PermissionKit in your Swift files:

```swift
import PermissionKit
```

Before requesting permissions, ensure you have added the necessary keys to your app’s `Info.plist` file.

To request a permission:

```swift
Permission.camera.request { status in
    switch status {
    case .authorized:
        print("Camera access granted")
    case .denied, .restricted:
        print("Camera access denied")
    case .notDetermined:
        print("Permission not determined yet")
    @unknown default:
        print("Unknown permission status")
    }
}
```

## Supported Permissions

| Permission      | Info.plist Key(s)                                 |
|-----------------|--------------------------------------------------|
| Camera          | `NSCameraUsageDescription`                        |
| Microphone      | `NSMicrophoneUsageDescription`                    |
| Location        | `NSLocationWhenInUseUsageDescription` <br> `NSLocationAlwaysAndWhenInUseUsageDescription` |
| Photo Library   | `NSPhotoLibraryUsageDescription`                   |
| Notifications   | No Info.plist key required                        |
| Contacts        | `NSContactsUsageDescription`                       |
| Calendars       | `NSCalendarsUsageDescription`                      |
| Reminders       | `NSRemindersUsageDescription`                      |
| Speech Recognition | `NSSpeechRecognitionUsageDescription`            |
| Bluetooth       | `NSBluetoothAlwaysUsageDescription`               |

Ensure the appropriate keys are present in your app’s `Info.plist` with user-facing descriptions explaining why the app needs each permission.

## API Reference

### Permission

A namespace that provides access to different permissions.

#### Properties

- `camera`: Access to camera permission.
- `microphone`: Access to microphone permission.
- `location`: Access to location permission.
- `photoLibrary`: Access to photo library permission.
- `notifications`: Access to notification permission.
- `contacts`: Access to contacts permission.
- `calendars`: Access to calendars permission.
- `reminders`: Access to reminders permission.
- `speechRecognition`: Access to speech recognition permission.
- `bluetooth`: Access to Bluetooth permission.

Each permission exposes the following method:

```swift
func request(completion: @escaping (PermissionStatus) -> Void)
```

Requests the permission and calls the completion handler with the resulting status.

### PermissionStatus

An enum representing the current status of a permission:

- `.authorized`: Permission granted.
- `.denied`: Permission denied.
- `.restricted`: Permission restricted (e.g., parental controls).
- `.notDetermined`: Permission not yet requested.
- `.provisional`: (For notifications) Temporary authorization.

## Example Usage

```swift
import PermissionKit

func requestCameraAccess() {
    Permission.camera.request { status in
        DispatchQueue.main.async {
            switch status {
            case .authorized:
                print("Camera access granted")
            case .denied, .restricted:
                print("Camera access denied or restricted")
            case .notDetermined:
                print("Camera permission not determined")
            @unknown default:
                print("Unknown permission status")
            }
        }
    }
}
```

---

For more information, please visit the [PermissionKit GitHub repository](https://github.com/vishalvaghasiya-ios/PermissionKit).

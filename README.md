# Unity Google Sign-In MacOS Plugin

## Description
This repo is a Unity MacOS plugin source code which is a wrapper for the official Google Sign-In MacOS SDK.

For more information on how to set up Google Sign-In for MacOS, see [Google Sign-In SDK for iOS & macOS](https://developers.google.com/identity/sign-in/ios/start).

## Prerequisites
- [Xcode](https://developer.apple.com/xcode/)
- [CocoaPods](https://cocoapods.org/)

## Use the plugin
Download the latest plugin in the [release page](https://github.com/stephenw310/Unity-GoogleSignIn-MacOS-Plugin/releases) and add it to your Unity project's `[...]/Plugins/macOS` directory

In Unity project, use `DllImport` to import the plugin and pass a callback function to handle the sign-in results.

Here is a sample code

```csharp
public delegate void Callback(string message);

[DllImport("libGoogleSignInPlugin")]
private static extern void _signIn(Callback UnityCallback);

// Sign-in results are serialized as a JSON string
void UnityCallback(string message)
{
    Debug.Log(message);
}
```

Sign-in result is serialized as a JSON string and passed to the callback function. 

Here is a sample JSON when sign-in is successful

```json
{
    "success": true,
    "accessToken": "xxxxxx",
    "idToken": "xxxxxx",
    "refreshToken": "xxxxxx",
    "userId": "1234567890", // optional
    "name": "John Doe", // optional
    "email": "john@gmail.com", // optional
    "serverAuthCode": "xxxxxx" // optional
}
```

Here is a sample JSON when sign-in failed.

```json
{
    "success": false,
    "errorCode": -5,
    "errorMessage": "The user cancelled the sign-in flow"
}
```

All possible error codes are listed in [Here](https://developers.google.com/identity/sign-in/ios/reference/Enums/GIDSignInErrorCode).

## Important Notes
1. The final `Info.plist` of the MacOS app must have a *OAuth client ID* and a custom URL scheme based on the *reversed client ID*. See [Add the client ID to your app](https://developers.google.com/identity/sign-in/ios/start-integrating#add_client_id) section in Google's official documentation.
2. Currently, your MacOS app also need the **Keychain Sharing** capability with `com.google.GIDSignIn` added as keychain groups. See this [github issue](https://github.com/google/GoogleSignIn-iOS/issues/165) for more information.

## Build the project
If you want to modify and build the plugin yourself, follow these steps:
1. Clone the repository
    ```shell
    git clone https://github.com/stephenw310/Unity-GoogleSignIn-MacOS-Plugin.git
    ```
2. Open the Xcode workspace file:
    ```shell
    open GoogleSignInPlugin.xcworkspace
    ```

3. Build the project in Xcode
4. Copy the generated `libGoogleSignInPlugin.dylib` to Unity project's `[...]/Plugins/macOS` directory

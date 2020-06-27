# Kakao Maps for Flutter

[![pub package](https://img.shields.io/pub/v/flutter_kakao_map.svg)](https://pub.dartlang.org/packages/flutter_kakao_map)

[Kakao Maps](https://developers.kakao.com/maps/) This is a Flutter plugin that provides a widget.

## Guide
The plugin relies on the Flutter framework for use on Android and iOS. There is currently no completion stage.

If you have any problems, please register as a problem or Pull Requset.

The DaumMap framework can only be tested on real devices in Android.

To use this plugin, iOS must select the built-in view preview in the following ways.
Add a boolean property to the app's `Info.plist` file using the key "io.flutter.embedded_views_preview"
And the value is YES.

The API exposed by this plugin is not yet stable and its specification can be changed.

## How to use

To use this plugin, add `flutter_kakao_map` to [Dependencies of pubspec.yaml file](https://flutter.io/platform-plugins/).

## Start

* Kakao Map Android API is available if you have to issue an application key and register the key hash.
For that, you need a Kakao account.
  * Register the developer and create an application on [Kakao Developers Console](https://developers.kakao.com/console/app).
  * Select a project to enable Kakao Maps.
  * Register Android and iOs in “Platform” from the Kakao Maps menu.
  * Android requires the values ​​of the app to match, and it works properly.

* Please refer to Kakao Maps API Key Registration Settings for more information. [here](https://apis.map.kakao.com/)

### Android

Specify the API key in the application manifest. `android/app/src/main/AndroidManifest.xml`:

``` xml
<manifest ...
>
    <! -Internet available->
    <Application
        Android:usesCleartextTraffic="true"
    >
        <! -Add cacao APP KEY->
        <Meta-data
            Android:name="com.kakao.sdk.AppKey"
            Android:value="[API_KEY]"/>
```

In the main activity of your application, you will add code.

``` java
import com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin;
//Change
import io.flutter.app.FlutterActivity;
public class MainActivity extends FlutterActivity {
    //add to
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FlutterKakaoMapPlugin.registerWith(registrarFor("com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin"));
    }
}
```

### iOS
It is necessary to add Framework used by DaumMap Framework to Target of the project.

- OpenGL ES.framework
- systemconfiguration.framework
- CoreLocation.framework
- QuartzCore.framework
- libc ++ tbd
- libxml2.tbd
- libsqlite3.tbd

Add a Boolean property to your app's `Info.plist` file to select the built-in view preview.
Set the key `io.flutter.embedded_views_preview` and the value of" YES "and enter the API key value.
``` xml
<key>KAKAO_APP_KEY</key>
<string>[APP_KEY]</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

In the terminal go to the project and ios folder and enter pod install.

### How to use 
You can now add the `FlutterKakaoMap` widget to your widget tree.

You can use the delivered `KakaoMapViewController` to control the map view.
The `onMapCreated` callback of` FlutterKakaoMap`.

### Sample Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyAppOne(),
    );
  }
}

class MyAppOne extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppOne> {
  KakaoMapController mapController;
  MapPoint _visibleRegion = MapPoint(37.5087553, 127.0632877);
  CameraPosition _kInitialPosition =
      CameraPosition(target: LatLng(37.5087553, 127.0632877), zoom: 5);

  void onMapCreated(KakaoMapController controller) async {
    final MapPoint visibleRegion = await controller.getMapCenterPoint();
    setState(() {
      mapController = controller;
      _visibleRegion = visibleRegion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter KakaoMap example')),
      body: Column(
        children: [
          Center(
              child: SizedBox(
                  width: 300.0,
                  height: 200.0,
                  child: KakaoMap(
                      onMapCreated: onMapCreated,
                      initialCameraPosition: _kInitialPosition)))
        ],
      ),
    );
  }
}
```

See the `example` directory for a complete sample app.

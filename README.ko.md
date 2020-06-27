# Kakao Maps for Flutter

[![pub package](https://img.shields.io/pub/v/flutter_kakao_map.svg)](https://pub.dartlang.org/packages/flutter_kakao_map)

[Kakao Maps](https://apis.map.kakao.com/) 위젯을 제공하는 Flutter 플러그인.

## 안내
플러그인은 Android 및 iOS에서 사용하기 위한 Flutter 프레임워크에 의존합니다. 현재 완성 단계가 아닙니다.

발견된 문제는 이슈로 등록해 주시거나 Pull Requset 주시면 감사하겠습니다.

DaumMap 프레임워크는 Android 경우 실 기기에서만 테스트 가능합니다.

iOS에서이 플러그인을 사용하려면 다음을 통해 내장 된 뷰 미리보기를 선택해야합니다.
키 'io.flutter.embedded_views_preview'를 사용하여 앱의 `Info.plist` 파일에 부울 속성 추가
그리고 값은 YES입니다.

이 플러그인에 의해 노출 된 API는 아직 안정적이지 않으며, 스펙이 변경될 수 있습니다.

## 사용법

이 플러그인을 사용하려면`flutter_kakao_map`를 [pubspec.yaml 파일의 종속성](https://flutter.io/platform-plugins/)으로 추가하십시오.

## 시작하기

* Kakao 지도 Android API 는 앱 키 발급 및 키 해시를 등록해야만 사용 가능합니다.
이를 위해서는 카카오 계정이 필요합니다.
  * [Kakao Developers Console](https://developers.kakao.com/console/app)에서 개발자 등록 및 앱 생성하세요.
  * Kakao Maps를 활성화하려는 프로젝트를 선택하십시오.
  * Kakao Maps 메뉴에서 "플랫폼"에서 Android 및 iOs를 등록하세요.
  * Android는 앱의 키해시 값이 일치해야 정상적으로 작동합니다.

* Kakao Maps API 키 등록 설정을 자세히 보려면 참고해주세요. [here](https://apis.map.kakao.com/)

### Android

애플리케이션 매니페스트에서 API 키를 지정하십시오. `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...
>
    <!-- 인터넷 허용 -->
    <application
        android:usesCleartextTraffic="true"
    >
        <!--  카카오 APP KEY 추가  -->
        <meta-data
            android:name="com.kakao.sdk.AppKey"
            android:value="[API_KEY]"/>
```

애플리케이션 메인엑티비티에서 코드를 추가하세요.

``` java
import com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin;
// 변경
import io.flutter.app.FlutterActivity;
public class MainActivity extends FlutterActivity {
  // 추가
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FlutterKakaoMapPlugin.registerWith(registrarFor("com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin"));
    }
}
```

### iOS
프로젝트의 Target에 DaumMap Framework가 사용하는 Framework들을 추가 해야 합니다. 

- OpenGLES.framework
- systemconfiguration.framework
- CoreLocation.framework
- QuartzCore.framework
- libc++.tbd
- libxml2.tbd
- libsqlite3.tbd

앱의`Info.plist` 파일에 부울 속성을 추가하여 내장 된 뷰 미리보기를 선택합니다.
키`io.flutter.embedded_views_preview`와 'YES'값으로 설정하고 API키값을 넣어줍니다.
``` xml
<key>KAKAO_APP_KEY</key>
<string>[APP_KEY]</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

터미널에서 project/ios 폴더로 가서 pod install을 입력하세요.

### 사용법
이제 위젯 트리에`FlutterKakaoMap` 위젯을 추가 할 수 있습니다.

전달되는`KakaoMapViewController`를 사용하여 맵 뷰를 제어 할 수 있습니다.
`FlutterKakaoMap`의`onMapCreated` 콜백.

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

완전한 샘플 앱은`example` 디렉토리를 참조하십시오.

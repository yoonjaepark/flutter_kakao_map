package com.yoonjaepark.flutter_kakao_map_example;

import android.os.Bundle;
//    변경
import com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    //    추가
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FlutterKakaoMapPlugin.registerWith(registrarFor("com.yoonjaepark.flutter_kakao_map.FlutterKakaoMapPlugin"));
    }
//
}
import 'package:flutter/material.dart';
import 'package:flutter_social_login_prac/screens/sample_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  // 네이티브앱키를 init
  KakaoSdk.init(nativeAppKey: '3e1e8463c23f312508da208373b33e8a');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SampleScreen(),
    );
  }
}

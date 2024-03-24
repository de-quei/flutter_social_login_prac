// 로고 버튼을 클릭하여 로그인을 실행하고, 로그아웃 버튼으로 로그아웃을 처리하는 화면입니다.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social_login_prac/login_platform.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;

class SampleScreen extends StatefulWidget {
  const SampleScreen({Key? key}) : super(key: key);

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {
  // StatefulWidget으로 만들고, 현재 로그인한 플랫폼을 저장할 변수를 선언.
  // Stateful로 상태관리
  LoginPlatform _loginPlatform = LoginPlatform.none;

  void signInWithKakao() async {
    try {
      // isKakaoTalkInstalled()로 카카오톡 설치 여부를 확인.
      bool isInstalled = await isKakaoTalkInstalled();

      // 카카오톡이 설치되어 있다면 카카오톡을 실행하여 로그인을 진행.
      // 설치되어있지 않다면 웹으로 로그인을 진행합니다.
      // 필자의 경우, 카카오톡 미설치로 인하여 웹으로 실행
      // 로그인을 성공했다면 OAuthToken으로 accessToken 값을 받아올 수 있음.
      // 이 토큰 값으로 유저정보를 확인하는 요청을 보내면, 이름과 이메일 정보를 얻을 수 있음. (이메일은 동의 필요)
      // 로그인 상태값을 갱신시켜줍니다.
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });
    } catch (error) {
      print('카카오톡으로 로그인 실패 : $error');
    }
  }

  // 로그아웃 메소드
  void signOut() async {
    switch (_loginPlatform) {
      // 다양한 플랫폼 실습
      case LoginPlatform.kakao:
        await UserApi.instance
            .logout(); // 로그아웃 처리 로직 / 로그인 상태값을 false로, 현재 로그인 플랫폼을 none으로 갱신
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  // main.dart로 전달되는 부분
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loginPlatform != LoginPlatform.none
            ? _logoutButton()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _loginButton(
                    'kakao_logo',
                    signInWithKakao,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _loginButton(String path, VoidCallback onTap) {
    return Card(
      elevation: 5.0,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage('asset/image/$path.png'),
        width: 60,
        height: 60,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(35.0),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _logoutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          const Color(0xff0165E1),
        ),
      ),
      child: const Text('로그아웃'),
    );
  }
}

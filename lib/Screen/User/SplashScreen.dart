import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ono/main.dart';
import 'package:provider/provider.dart';

import '../../Model/Common/LoginStatus.dart';
import '../../Provider/UserProvider.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 유저의 로그인 상태를 확인하는 함수
  _checkLoginStatus() async {
    // UserProvider에서 로그인 상태를 가져옴
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.autoLogin();

    print('login status: ${userProvider.loginStatus}');
    // 2초간 대기 후 상태 체크

    await Future.delayed(const Duration(seconds: 2), () {});
    while (userProvider.loginStatus == LoginStatus.waiting) {
      await Future.delayed(const Duration(seconds: 1));
    }

    // 로그인 상태에 따른 화면 이동
    if (userProvider.loginStatus == LoginStatus.login) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const MyHomePage()), // 로그인 상태면 HomeScreen으로
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                const LoginScreen()), // 로그아웃 상태면 LoginScreen으로
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCBEAB7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/Logo/GreenFrog.svg',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  '\"나만의 진정한 오답노트, OnO\"',
                  textStyle: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: 'HandWrite', // 손글씨 느낌의 폰트 사용
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 75), // 타이핑 속도 조절
                  cursor: '', // 커서를 빈 문자열로 설정하여 깜빡임을 없앰
                ),
              ],
              isRepeatingAnimation: false, // 한 번만 실행되도록 설정
            ),
          ],
        ),
      ),
    );
  }
}

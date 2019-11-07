import 'package:flutter/material.dart';
import 'dart:async';


class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State {

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset('assets/images/sennin_kuchu_fuyuu_tsue.png')
        )
      ),
    );
  }

  _startTimer() async {
    Timer(Duration(seconds: 2), () => _moveToMainScreen());
  }

  _moveToMainScreen() {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
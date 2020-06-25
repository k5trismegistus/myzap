import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myzap/utils/userStore.dart';


class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State {

  @override
  void initState() {
    super.initState();

    this.transition();
  }

  Future<void> transition() async {
    var login = await UserStore().detectLogin();

    if (login != null) {
      Navigator.pushReplacementNamed(context, '/top');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
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
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myzap/utils/userStore.dart';


class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _detectLogin();
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

  _detectLogin() async {
    FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    await UserStore().setUser(user);
    Navigator.pushReplacementNamed(context, '/top');
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/widgets.dart';
import 'package:myzap/utils/userStore.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState () => _LoginState();
}

class _LoginState extends State {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Center(
          child: Row(
            children: <Widget>[
              FlatButton(
                child: Text('Login'),
                onPressed: _handleSignIn,
              )
            ],
          )
        )
      )
    );
  }

  Future<void> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var user = await UserStore().login(credential);
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/top');
      return;
    }

    // TODO: Handle error
    return;
  }
}
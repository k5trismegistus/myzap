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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserStore _userStore = UserStore();

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

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    this._userStore.setUser(user);

    Navigator.pushReplacementNamed(context, '/top');
  }
}
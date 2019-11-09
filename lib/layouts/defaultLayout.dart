import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myzap/utils/userStore.dart';

class DefaultLayout extends StatelessWidget {
  final String title;
  final Widget page;
  final Widget floatingActionButton;

  const DefaultLayout({
    Key key,
    this.title,
    this.page,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseUser user = UserStore().getUser();
    print(user.photoUrl);

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      floatingActionButton: this.floatingActionButton,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Image.network(user.photoUrl),
            Text(user.displayName),
          ],
        ),
      ),
      body: this.page,
    );
  }
}
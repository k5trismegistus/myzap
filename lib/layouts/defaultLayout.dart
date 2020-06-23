import 'package:flutter/material.dart';
import 'package:myzap/models/myzap_user.dart';
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
    MyzapUser user = UserStore().getUser();

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      floatingActionButton: this.floatingActionButton,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Colors.blue,
            //   ),
            // ),
            Padding(padding: EdgeInsets.all(8)),
            ListTile(
              title: Text(user.displayName()),
              leading: Image.network(user.photoUrl()),
            ),
            Container(
              child: Text('Settings'),
              padding: EdgeInsets.only(top:16.0, left: 16.0),
            ),
            Card(
              child: ListTile(
                title: Text('Personal Place setting'),
                onTap: () {
                  Navigator.pushNamed(context, '/personalPlaces');
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Log out'),
                onTap: () async {
                  await UserStore().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              color: Colors.red,
            )
          ],
        ),
      ),
      body: this.page,
    );
  }
}
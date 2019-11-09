import 'package:firebase_auth/firebase_auth.dart';

class UserStore {
  FirebaseUser _user;
  static final UserStore _cachedInstance = UserStore._internal();

  factory UserStore() {
    return _cachedInstance;
  }

  UserStore._internal();

  void setUser(FirebaseUser user) {
    this._user = user;
  }

  FirebaseUser getUser() {
    return this._user;
  }

  void unsetUser() async {
    await FirebaseAuth.instance.signOut();
    this._user = null;
  }
}

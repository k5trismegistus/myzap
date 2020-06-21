import 'package:firebase_auth/firebase_auth.dart';
import 'package:myzap/models/myzap_user.dart';

class UserStore {
  FirebaseUser _user;
  static final UserStore _cachedInstance = UserStore._internal();

  factory UserStore() {
    return _cachedInstance;
  }

  UserStore._internal();

  Future<void> setUser(FirebaseUser user) async {
    await MyzapUser.initOrCreate(user.uid);
    this._user = user;
  }

  FirebaseUser getUser() {
    return this._user;
  }

  Future<void> unsetUser() async {
    await FirebaseAuth.instance.signOut();
    this._user = null;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:myzap/models/myzap_task.dart';
import 'package:myzap/models/myzap_user.dart';

class UserStore {
  MyzapUser _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final UserStore _cachedInstance = UserStore._internal();

  factory UserStore() {
    return _cachedInstance;
  }

  UserStore._internal();

  Future<MyzapUser> detectLogin() async {
    FirebaseUser firebaseUser = await _auth.currentUser();

    if (firebaseUser == null) {
      return null;
    }

    await this._setUser(firebaseUser);
    return this._user;
  }

  Future<MyzapUser> login(AuthCredential credential) async {
    FirebaseUser firebaseUser = (await _auth.signInWithCredential(credential)).user;
    if (firebaseUser != null) {
      await this._setUser(firebaseUser);
      print(this._user.toMap());
      return this._user;
    }
    // TODO: handle error
    print('login failed');
  }

  Future<void> _setUser(FirebaseUser firebaseUser) async {
    var user = await MyzapUser.initOrCreate(firebaseUser);
    this._user = user;
  }

  MyzapUser getUser() {
    return this._user;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    this._user = null;
  }
}

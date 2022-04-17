import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../utils/exceptions.dart';
import '../models/user_model.dart';

class FirebaseAuthUtil {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _mapUser(result.user);
    } on FirebaseAuthException catch (e) {
      throw FireBaseException(e.message ?? 'Unknown Error');
    } catch (e) {
      throw const FireBaseException('Unknown Error. Please try again');
    }
  }

  Future<UserModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _mapUser(result.user);
    } on FirebaseAuthException catch (e) {
      throw FireBaseException(e.message ?? 'Unknown Error');
    } catch (e) {
      throw const FireBaseException('Unknown Error. Please try again');
    }
  }

  Future<void> signOut() => _auth.signOut();

  Stream<UserModel> get userStream => _auth.authStateChanges().map(_mapUser);

  UserModel _mapUser(User? user) => user == null
      ? UserModel.empty()
      : UserModel(id: user.uid, email: user.email ?? '');

  UserModel get currentUser => _mapUser(_auth.currentUser);
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/user_model.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils/exceptions.dart';

final viewToggleProvider = StateProvider<bool>((_) => true);

final signInAutoValidateProvider = StateProvider<AutovalidateMode>((_) => AutovalidateMode.disabled);

final registerAutoValidateProvider = StateProvider<AutovalidateMode>((_) => AutovalidateMode.disabled);

final authenticationProvider =
    StateNotifierProvider<AuthenticationNotifier, AuthenticationState>(
        (ref) => AuthenticationNotifier(ref.read));

abstract class AuthenticationState {
  const AuthenticationState();
}

class AuthenticationIdleState extends AuthenticationState {
  const AuthenticationIdleState();
}

class AuthenticationLoadingState extends AuthenticationState {
  const AuthenticationLoadingState();
}

class AuthenticationSignInState extends AuthenticationState {
  final UserModel user;
  const AuthenticationSignInState(this.user);
}

class AuthenticationRegisterState extends AuthenticationState {
  final UserModel user;
  const AuthenticationRegisterState(this.user);
}

class AuthenticationErrorState extends AuthenticationState {
  final String message;
  const AuthenticationErrorState(this.message);
}

class AuthenticationNotifier extends StateNotifier<AuthenticationState> {
  final Reader read;
  AuthenticationNotifier(this.read) : super(const AuthenticationIdleState());

  Future<void> signIn({required String email, required String password}) async {
    final firebaseAuth = read(firebaseAuthProvider);
    try {
      state = const AuthenticationLoadingState();
      final result =
          await firebaseAuth.signIn(email: email, password: password);
      state = AuthenticationSignInState(result);
    } on FireBaseException catch (e) {
      state = AuthenticationErrorState(e.message);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final firebaseAuth = read(firebaseAuthProvider);
    try {
      state = const AuthenticationLoadingState();
      final result =
          await firebaseAuth.register(email: email, password: password);
      read(cloudFirestoreProvider).addUser(result.id, name);
      state = AuthenticationSignInState(result);
    } on FireBaseException catch (e) {
      state = AuthenticationErrorState(e.message);
    }
  }

  void clearState() => state = const AuthenticationIdleState();
}

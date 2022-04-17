import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../providers/authentication_provider.dart';
import '../widgets/register_widget.dart';
import '../widgets/signin_widget.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0 * 2),
                child: Text(
                  'Social Wall',
                  textAlign: TextAlign.center,
                  style: textTheme.headline3!.copyWith(color: Colors.black),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0 * 3),
              child: Consumer(builder: (context, ref, child) {
                ref.listen<AuthenticationState>(authenticationProvider,
                    (_, state) {
                  if (state is AuthenticationSignInState) {
                    _gotoDashboard();
                  } else if (state is AuthenticationRegisterState) {
                    _gotoDashboard();
                    _toggleView(ref);
                  } else if (state is AuthenticationErrorState) {
                    context.showSnackbar(state.message);
                  }
                });
                final state = ref.watch(viewToggleProvider);
                return AnimatedSwitcher(
                  child: state ? const SignInWidget() : const RegisterWidget(),
                  duration: const Duration(milliseconds: 400),
                  reverseDuration: const Duration(milliseconds: 400),
                );
              }),
            ),
            const SizedBox(height: 8.0 * 5),
          ],
        ),
      ),
    );
  }

  void _init() => ref.read(firebaseAuthProvider).userStream.listen((e) {
        if (!e.isEmpty) _gotoDashboard();
      });

  // void _showSnackbar(String message) =>
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(message),
  //     ));

  void _gotoDashboard() => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()));

  void _toggleView(WidgetRef ref) =>
      ref.read(viewToggleProvider.notifier).update((_) => false);
}

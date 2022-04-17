import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../providers/authentication_provider.dart';

class SignInWidget extends ConsumerStatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends ConsumerState<SignInWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(authenticationProvider);
      return IgnorePointer(
        ignoring: state is AuthenticationLoadingState,
        child: Consumer(
          builder: (context, ref, child) {
            final autoValidate = ref.watch(signInAutoValidateProvider);
            return Form(
              key: _formKey,
              autovalidateMode: autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  child!,
                  state is AuthenticationLoadingState
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _signIn, child: const Text('SignIn')),
                  const SizedBox(height: 8.0),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Don\'t have an account? ',
                          style: textTheme.bodyText2!
                              .copyWith(color: Colors.black),
                          children: [
                            WidgetSpan(
                                child: InkWell(
                              onTap: _toggleView,
                              child: Text(
                                'Register',
                                style: textTheme.bodyText1?.copyWith(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ))
                          ])),
                ],
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SignIn',
                textAlign: TextAlign.center,
                style: textTheme.headline5,
              ),
              const SizedBox(height: 8.0 * 3),
              TextFormField(
                controller: _emailController,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter an email';
                  } else if (!value.trim().isValidEmail()) {
                    return 'Please enter a valid email';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _passwordController,
                maxLines: 1,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  hintText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter a password';
                  } else if (value.trim().length < 6) {
                    return 'Password must be of 6 characters';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _signIn() async {
    if (await context.isConnected) {
      if (_formKey.currentState!.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());
        ref.read(authenticationProvider.notifier).signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      } else {
        ref
            .read(signInAutoValidateProvider.notifier)
            .update((_) => AutovalidateMode.always);
      }
    }
  }

  void _toggleView() =>
      ref.read(viewToggleProvider.notifier).update((state) => !state);
}

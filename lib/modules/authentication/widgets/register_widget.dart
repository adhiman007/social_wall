import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../providers/authentication_provider.dart';

class RegisterWidget extends ConsumerStatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends ConsumerState<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            final autoValidate = ref.watch(registerAutoValidateProvider);
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
                          onPressed: _register, child: const Text('Register')),
                  const SizedBox(height: 8.0),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: 'Already have an account? ',
                          style: textTheme.bodyText2!
                              .copyWith(color: Colors.black),
                          children: [
                            WidgetSpan(
                                child: InkWell(
                              onTap: _toggleView,
                              child: Text(
                                'Login',
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
                'Registration',
                textAlign: TextAlign.center,
                style: textTheme.headline5,
              ),
              const SizedBox(height: 8.0 * 2),
              TextFormField(
                controller: _nameController,
                maxLines: 1,
                maxLength: 25,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  hintText: 'Name',
                  counterText: '',
                ),
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter your name';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 8.0),
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
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  hintText: 'Password',
                ),
                validator: (value) => _validatePassword(
                    value!.trim(), _confirmPasswordController.text.trim()),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _confirmPasswordController,
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                  hintText: 'Confirm Password',
                ),
                validator: (value) => _validatePassword(
                    value!.trim(), _passwordController.text.trim()),
              ),
              const SizedBox(height: 8.0 * 2),
            ],
          ),
        ),
      );
    });
  }

  String? _validatePassword(String v1, String v2) {
    if (v1.isEmpty) {
      return 'Please enter a password';
    } else if (v1.trim().length < 6) {
      return 'Password must be of 6 characters';
    } else if (v1 != v2) {
      return 'Password not matching';
    } else {
      return null;
    }
  }

  Future<void> _register() async {
    if (await context.isConnected) {
      if (_formKey.currentState!.validate()) {
        FocusScope.of(context).requestFocus(FocusNode());
        ref.read(authenticationProvider.notifier).register(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      } else {
        ref
            .read(registerAutoValidateProvider.notifier)
            .update((_) => AutovalidateMode.always);
      }
    }
  }

  void _toggleView() =>
      ref.read(viewToggleProvider.notifier).update((state) => !state);
}

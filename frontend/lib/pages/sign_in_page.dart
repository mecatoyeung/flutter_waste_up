import 'package:flutter/material.dart';
import 'package:waste_up/pages/authentication_page.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const AuthenticationPage(isSignUp: false);
}

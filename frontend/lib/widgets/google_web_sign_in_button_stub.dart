import 'package:flutter/widgets.dart';

class GoogleWebSignInButton extends StatelessWidget {
  const GoogleWebSignInButton({super.key, required this.onSignedIn});

  final Future<void> Function() onSignedIn;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
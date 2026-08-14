import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as google_web;
import 'package:waste_up/services/auth_service.dart';

class GoogleWebSignInButton extends StatefulWidget {
  const GoogleWebSignInButton({super.key, required this.onSignedIn});

  final Future<void> Function() onSignedIn;

  @override
  State<GoogleWebSignInButton> createState() => _GoogleWebSignInButtonState();
}

class _GoogleWebSignInButtonState extends State<GoogleWebSignInButton> {
  StreamSubscription<GoogleSignInAccount?>? _accountSubscription;
  Future<void>? _initialization;
  bool _handlingSignIn = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialization = _initialize();
  }

  Future<void> _initialize() async {
    final signIn = await AuthService.instance.getGoogleSignIn();
    _accountSubscription = signIn.onCurrentUserChanged.listen(_handleAccount);
  }

  Future<void> _handleAccount(GoogleSignInAccount? account) async {
    if (account == null || _handlingSignIn) return;

    _handlingSignIn = true;
    try {
      await AuthService.instance.completeGoogleSignIn(account);
      await widget.onSignedIn();
    } on AuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      _handlingSignIn = false;
    }
  }

  @override
  void dispose() {
    _accountSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Unable to initialize Google sign-in: ${snapshot.error}');
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 52,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 52,
              child: google_web.renderButton(
                configuration: google_web.GSIButtonConfiguration(
                  minimumWidth: 400,
                  text: google_web.GSIButtonText.continueWith,
                  shape: google_web.GSIButtonShape.rectangular,
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        );
      },
    );
  }
}
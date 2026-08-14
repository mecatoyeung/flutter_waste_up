import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:waste_up/config/env_config.dart';

class AuthService {
  AuthService._();

  static final instance = AuthService._();

  String? _accessToken;
  GoogleSignIn? _googleSignIn;

  bool get isAuthenticated => _accessToken != null;

  Future<void> signUp({
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _post('/account/signup', {
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
    });

    if (response.statusCode != 201) {
      throw AuthException(_errorMessage(response));
    }
  }

  Future<void> signIn({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    final response = await _post('/account/signin', {
      'username': username,
      'password': password,
      'rememberMe': rememberMe,
    });

    if (response.statusCode != 200) {
      throw AuthException(_errorMessage(response));
    }

    final body = _decodeBody(response);
    final accessToken = body['accessToken'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw const AuthException('The server did not return an access token.');
    }

    _accessToken = accessToken;
  }

  Future<void> signInWithGoogle({bool rememberMe = true}) async {
    try {
      if (kIsWeb) {
        throw const AuthException(
          'Use the Google sign-in button displayed below to continue.',
        );
      }

      final googleSignIn = await getGoogleSignIn();
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }

      await completeGoogleSignIn(googleUser, rememberMe: rememberMe);
    } on AuthException {
      rethrow;
    } on Exception catch (error) {
      throw AuthException(
        'Google sign-in failed. Verify the OAuth web client and its authorized JavaScript origin. Details: $error',
      );
    }
  }

  Future<GoogleSignIn> getGoogleSignIn() async {
    final googleClientId = await _getGoogleClientId();
    return _googleSignIn ??= GoogleSignIn(
      clientId: googleClientId,
      scopes: const ['email', 'profile'],
    );
  }

  Future<void> completeGoogleSignIn(
    GoogleSignInAccount googleUser, {
    bool rememberMe = true,
  }) async {
    final googleAuthentication = await googleUser.authentication;
    final idToken = googleAuthentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw const AuthException('Google did not return an ID token.');
    }

    final response = await _post('/account/google', {
      'idToken': idToken,
      'rememberMe': rememberMe,
    });
    if (response.statusCode != 200) {
      throw AuthException(_errorMessage(response));
    }

    _storeAccessToken(response);
  }

  void signOut() => _accessToken = null;

  Future<http.Response> _post(String path, Map<String, dynamic> body) => http
      .post(
        Uri.parse('${EnvConfig.apiBaseUrl}$path'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
      .timeout(const Duration(seconds: 15));

  Future<String> _getGoogleClientId() async {
    final response = await http
        .get(Uri.parse('${EnvConfig.apiBaseUrl}/account/google/config'))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw AuthException(_errorMessage(response));
    }

    final clientId = _decodeBody(response)['clientId'] as String?;
    if (clientId == null || clientId.isEmpty) {
      throw const AuthException('Google sign-in is not configured.');
    }

    return clientId;
  }

  void _storeAccessToken(http.Response response) {
    final body = _decodeBody(response);
    final accessToken = body['accessToken'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw const AuthException('The server did not return an access token.');
    }

    _accessToken = accessToken;
  }

  String _errorMessage(http.Response response) {
    final body = _decodeBody(response);
    final error = body['error'];
    if (error is String && error.isNotEmpty) return error;

    final errors = body['errors'];
    if (errors is List && errors.isNotEmpty) {
      final firstError = errors.first;
      if (firstError is Map && firstError['description'] is String) {
        return firstError['description'] as String;
      }
    }

    return 'Unable to complete the request. Please try again.';
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body is Map<String, dynamic> ? body : <String, dynamic>{};
    } on FormatException {
      return <String, dynamic>{};
    }
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}

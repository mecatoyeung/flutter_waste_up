import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:waste_up/config/env_config.dart';

class AuthService {
  AuthService._();

  static final instance = AuthService._();

  String? _accessToken;

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
  }) async {
    final response = await _post('/account/signin', {
      'username': username,
      'password': password,
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

  void signOut() => _accessToken = null;

  Future<http.Response> _post(String path, Map<String, String> body) => http
      .post(
        Uri.parse('${EnvConfig.apiBaseUrl}$path'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      )
      .timeout(const Duration(seconds: 15));

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

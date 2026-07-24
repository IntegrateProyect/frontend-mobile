import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatbotSessionExpiredException implements Exception {
  final String message;

  const ChatbotSessionExpiredException([
    this.message = 'Tu sesión expiró. Inicia sesión nuevamente.',
  ]);

  @override
  String toString() => message;
}

class ChatbotApiException implements Exception {
  final int statusCode;
  final String message;

  const ChatbotApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => message;
}

abstract class ChatbotRemoteDataSource {
  Future<Map<String, dynamic>> sendMessage({
    required String token,
    required String message,
    bool search = false,
  });

  Future<bool> checkHealth();
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  static String get _baseUrl {
    final configuredUrl = dotenv.env['CHATBOT_API_URL']?.trim();

    final url = configuredUrl == null || configuredUrl.isEmpty
        ? 'http://localhost:8000'
        : configuredUrl;

    return url.replaceFirst(RegExp(r'/$'), '');
  }

  @override
  Future<Map<String, dynamic>> sendMessage({
    required String token,
    required String message,
    bool search = false,
  }) async {
    final cleanToken = token
        .trim()
        .replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '');

    if (cleanToken.isEmpty) {
      throw const ChatbotSessionExpiredException(
        'No se encontró una sesión activa.',
      );
    }

    final response = await http
        .post(
      Uri.parse('$_baseUrl/chat/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $cleanToken',
      },
      body: jsonEncode({
        'message': message.trim(),
        'search': search,
      }),
    )
        .timeout(const Duration(seconds: 250));

    final Map<String, dynamic> body = _decodeBody(response.body);

    if (response.statusCode == 401) {
      throw const ChatbotSessionExpiredException();
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ChatbotApiException(
        statusCode: response.statusCode,
        message: _extractErrorMessage(
          body,
          fallback: 'No se pudo enviar el mensaje.',
        ),
      );
    }

    return body;
  }

  @override
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(
        Uri.parse('$_baseUrl/chat/health'),
        headers: const {
          'Accept': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode != 200) {
        return false;
      }

      final body = _decodeBody(response.body);

      return body['status'] == 'ok';
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic> _decodeBody(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }

      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{
        'detail': responseBody,
      };
    }
  }

  String _extractErrorMessage(
      Map<String, dynamic> body, {
        required String fallback,
      }) {
    final possibleMessages = [
      body['detail'],
      body['message'],
      body['error'],
    ];

    for (final value in possibleMessages) {
      final text = value?.toString().trim() ?? '';

      if (text.isNotEmpty) {
        return text;
      }
    }

    return fallback;
  }
}
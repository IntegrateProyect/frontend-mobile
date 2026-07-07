// data/datasources/remote/chatbot_remote_datasource.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:orientate/core/utils/handlers.dart';

abstract class ChatbotRemoteDataSource {
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body, {String? studentId});
  Future<bool> checkHealth();
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  static String get _baseUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_URL no configurada en .env — revisa assets/.env y pubspec.yaml');
    }
    return url;
  }

  @override
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body, {String? studentId}) async {
    final headers = {
      'Content-Type': 'application/json',
      'X-Student-Id': ?studentId,
    };
    final response = await http.post(
      Uri.parse('$_baseUrl/chatbot/chat/'),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 20));
    return processResponse(response);
  }

  @override
  Future<bool> checkHealth() async {
    final response = await http.get(Uri.parse('$_baseUrl/chatbot/health'));
    final json = processResponse(response);
    return json['status'] == 'ok';
  }
}
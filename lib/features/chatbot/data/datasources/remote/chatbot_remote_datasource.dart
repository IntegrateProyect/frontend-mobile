// data/datasources/remote/chatbot_remote_datasource.dart
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/utils/handlers.dart';

abstract class ChatbotRemoteDataSource {
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body, {String? studentId});
  Future<bool> checkHealth();
}

class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  static final String _baseUrl = dotenv.env['CHATBOT_API_URL'] ?? '...';

  @override
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body, {String? studentId}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (studentId != null) 'X-Student-Id': studentId,
    };
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/'),
      headers: headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 20)); // el LLM puede tardar
    return processResponse(response); // reutiliza core/utils/handlers.dart
  }

  @override
  Future<bool> checkHealth() async {
    final response = await http.get(Uri.parse('$_baseUrl/chat/health'));
    final json = processResponse(response);
    return json['status'] == 'ok';
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

Map<String, String> getHeaders([String? token]) {
  final headers = {
    'Content-Type': 'application/json',
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
  };
  
  if (kDebugMode) {
    print('DEBUG HEADERS: $headers');
  }
  
  return headers;
}

dynamic processResponse(http.Response response) {
  final body = response.body;
  final dynamic json = body.isNotEmpty ? jsonDecode(body) : null;

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return json;
  } else {
    if (kDebugMode) {
      print('--- ERROR DE API ---');
      print('Status: ${response.statusCode}');
      print('URL: ${response.request?.url}');
      print('Body: $body');
    }
    
    final message = json != null && json['message'] != null 
        ? json['message'] 
        : (json != null && json['error'] != null ? json['error'] : 'Error: ${response.statusCode}');
        
    throw Exception(message);
  }
}

class ApiLogger {
  static void request(String method, String url, dynamic data) {
    if (kDebugMode) {
      print('--> $method $url');
      if (data != null) print('Body: $data');
    }
  }

  static void response(String method, String url, dynamic data) {
    if (kDebugMode) {
      print('<-- $method $url');
      if (data != null) print('Response: $data');
    }
  }

  static void error(String method, String url, dynamic error) {
    if (kDebugMode) {
      print('XXX $method $url - ERROR: $error');
    }
  }
}

import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart'; // ✅ for debugPrint
import 'package:frontend/data/api_result.dart';
import 'package:frontend/utils/sessionmanager.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://192.168.1.10:8080/api";

  // ✅ Common headers
  Future<Map<String, String>> _getHeaders({
    bool isJson = true,
    bool requireAuth = true,
  }) async {
    final headers = <String, String>{};

    // Only add token if required
    if (requireAuth) {
      final token = await SessionManager.getToken();
      if (token == null) throw Exception("No valid token available.");
      headers['Authorization'] = 'Bearer $token';
    }

    if (isJson) headers['Content-Type'] = 'application/json';
    return headers;
  }

  // ✅ LOGIN (no auth header)
  Future<ApiResult<dynamic>> login(Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl/auth/login');
      final headers = await _getHeaders(requireAuth: false); // 🚨 skip token
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e, stack) {
      debugPrint("❌ LOGIN failed: $e\n$stack");
      return ApiResult.failure("Network error: $e");
    }
  }

  // ✅ GET
  Future<ApiResult<dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e, stack) {
      debugPrint("❌ GET $endpoint failed: $e\n$stack");
      return ApiResult.failure("Network error: $e");
    }
  }

  // ✅ POST
  Future<ApiResult<dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requireAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e, stack) {
      debugPrint("❌ POST $endpoint failed: $e\n$stack");
      return ApiResult.failure("Network error: $e");
    }
  }

  // ✅ PUT
  Future<ApiResult<dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e, stack) {
      debugPrint("❌ PUT $endpoint failed: $e\n$stack");
      return ApiResult.failure("Network error: $e");
    }
  }

  // ✅ PATCH
  Future<ApiResult<dynamic>> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e, stack) {
      debugPrint("❌ PATCH $endpoint failed: $e\n$stack");
      return ApiResult.failure("Network error: $e");
    }
  }

  // ✅ DELETE
  Future<ApiResult<dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e, stack) {
      debugPrint("❌ DELETE $endpoint failed: $e\n$stack");
      return ApiResult.failure("Network error: $e");
    }
  }

  // ✅ Multipart Upload
  Future<ApiResult<dynamic>> upload(
    String endpoint,
    Map<String, String> fields, {
    io.File? file,
    Uint8List? fileBytes,
    String? fileName,
    String fileField = "file",
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(isJson: false);

      var request = http.MultipartRequest('POST', url)..headers.addAll(headers);
      request.fields.addAll(fields);

      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath(fileField, file.path),
        );
      } else if (fileBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            fileField,
            fileBytes,
            filename: fileName ?? 'upload.bin',
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } catch (e, stack) {
      debugPrint("❌ UPLOAD $endpoint failed: $e\n$stack");
      return ApiResult.failure("Upload error: $e");
    }
  }

  // ✅ Response handler
  ApiResult<dynamic> _handleResponse(http.Response response) {
    final status = response.statusCode;
    final body = response.body.isNotEmpty ? response.body : null;

    debugPrint(
      "📡 Response (${response.request?.url}): "
      "Status $status | Body: $body",
    );

    if (status >= 200 && status < 300) {
      return ApiResult.success(body != null ? jsonDecode(body) : null);
    } else {
      return ApiResult.failure("API Error ($status): $body");
    }
  }
}

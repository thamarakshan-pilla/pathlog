import 'package:dio/dio.dart';

/// The ONLY place in the codebase that knows the backend exists.
/// All HTTP calls go through here.
/// Swap Cloudflare for any other backend by changing only this file.
class CloudflareClient {
  late final Dio _dio;

  // Replace with your actual Cloudflare Worker URL
  static const _baseUrl = 'https://your-worker.your-subdomain.workers.dev';

  CloudflareClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Request/response logging — remove in production
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  /// Upload a single event log.
  /// Returns true if the backend confirmed receipt (2xx).
  /// The backend should upsert by event ID — idempotent by design.
  Future<bool> uploadEventLog({
    required String id,
    required String walkId,
    required String eventType,
    required String payload,
    required DateTime createdAt,
  }) async {
    try {
      final response = await _dio.post(
        '/events',
        data: {
          'id': id,
          'walkId': walkId,
          'eventType': eventType,
          'payload': payload,
          'createdAt': createdAt.toIso8601String(),
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      // Rethrow with a clean message — sync_runner handles the retry logic
      throw SyncUploadException('Event log upload failed: ${e.message}');
    }
  }

  /// Upload a batch of GPS points for a walk.
  /// Batching reduces HTTP overhead — one request per walkId, not one per point.
  Future<bool> uploadGpsPoints({
    required String walkId,
    required List<Map<String, dynamic>> points,
  }) async {
    try {
      final response = await _dio.post(
        '/gps',
        data: {'walkId': walkId, 'points': points},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw SyncUploadException('GPS batch upload failed: ${e.message}');
    }
  }
}

/// Thrown by CloudflareClient on any upload failure.
/// sync_runner catches this and writes to errorMessage in Drift.
class SyncUploadException implements Exception {
  final String message;
  const SyncUploadException(this.message);

  @override
  String toString() => message;
}

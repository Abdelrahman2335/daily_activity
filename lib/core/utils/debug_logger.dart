import 'package:flutter/foundation.dart';

class DebugLogger {
  static const bool _enableLogging = kDebugMode; // Only log in debug mode

  static void log(String message, {String? tag}) {
    if (!_enableLogging) return;

    final timestamp = DateTime.now().toIso8601String();
    final logTag = tag != null ? '[$tag]' : '[DEBUG]';
    debugPrint('$timestamp $logTag $message');
  }

  static void logEvent(String eventName, {Map<String, dynamic>? data}) {
    if (!_enableLogging) return;

    log('🎯 Event: $eventName', tag: 'EVENT');
    if (data != null && data.isNotEmpty) {
      data.forEach((key, value) {
        log('   • $key: $value', tag: 'EVENT');
      });
    }
  }

  static void logState(String stateName, {Map<String, dynamic>? data}) {
    if (!_enableLogging) return;

    log('📊 State: $stateName', tag: 'STATE');
    if (data != null && data.isNotEmpty) {
      data.forEach((key, value) {
        log('   • $key: $value', tag: 'STATE');
      });
    }
  }

  static void logError(
    String error, {
    String? context,
    StackTrace? stackTrace,
  }) {
    if (!_enableLogging) return;

    log('❌ Error: $error', tag: 'ERROR');
    if (context != null) {
      log('   Context: $context', tag: 'ERROR');
    }
    if (stackTrace != null) {
      log('   StackTrace: $stackTrace', tag: 'ERROR');
    }
  }

  static void logSuccess(String message, {Map<String, dynamic>? data}) {
    if (!_enableLogging) return;

    log('✅ Success: $message', tag: 'SUCCESS');
    if (data != null && data.isNotEmpty) {
      data.forEach((key, value) {
        log('   • $key: $value', tag: 'SUCCESS');
      });
    }
  }

  static void logApiCall(
    String endpoint, {
    String? method,
    Map<String, dynamic>? params,
  }) {
    if (!_enableLogging) return;

    log('🌐 API Call: ${method ?? 'GET'} $endpoint', tag: 'API');
    if (params != null && params.isNotEmpty) {
      params.forEach((key, value) {
        log('   • $key: $value', tag: 'API');
      });
    }
  }

  static void logFirestore(
    String operation, {
    String? collection,
    Map<String, dynamic>? data,
  }) {
    if (!_enableLogging) return;

    final collectionInfo = collection != null ? ' in $collection' : '';
    log('🔥 Firestore: $operation$collectionInfo', tag: 'FIRESTORE');
    if (data != null && data.isNotEmpty) {
      data.forEach((key, value) {
        log('   • $key: $value', tag: 'FIRESTORE');
      });
    }
  }
}
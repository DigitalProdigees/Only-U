import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HelpersMethod {
  // Parse Int with Default Value
  int parseIntWithDefault(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  double parseDoubleWithDefault(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  // Helper function to safely parse integers
  int? parseIntSafely(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  // Parse the rating field
  String getRating(Map<String, dynamic> shop) {
    // Try different possible rating field names
    final rating = shop['rating'] ?? shop['Rating'] ?? shop['shop_rating'];

    if (rating == null) return '0.0';

    // Handle different rating types (double, int, string)
    if (rating is num) {
      return rating.toStringAsFixed(1);
    }

    return rating.toString();
  }

  // Helper method to safely parse errors
  static List<dynamic>? parseErrors(Map<String, dynamic> json) {
    var errorsField = json['Errors'] ?? json['errors'] ?? [];
    if (errorsField != null) {
      if (errorsField is List) {
        return List<dynamic>.from(errorsField);
      }
    }
    return [];
  }

  static String getFormattedTimeFromTimestamp(dynamic timestamp) {
    DateTime dateTime;

    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return 'Invalid time';
    }

    return DateFormat('h:mm a').format(dateTime); // e.g., 4:15 PM
  }
}

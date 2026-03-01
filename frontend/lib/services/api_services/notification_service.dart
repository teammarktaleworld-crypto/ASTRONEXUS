import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../App/Model/notification_model.dart';
import '../API/APIservice.dart'; // make sure baseurl is defined here

class NotificationService {
  final String token;

  NotificationService({required this.token});

  /// Fetch notifications with debug logs
  Future<List<NotificationModel>> getNotifications() async {
    final url = Uri.parse('$baseurl/api/notifications');
    print('📡 Fetching notifications from: $url');
    print('🛡️ Using token: $token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Detect if it's a list or map
        final notificationsList = data is List ? data : data['notifications'] ?? [];
        print('🔹 Parsed notifications count: ${notificationsList.length}');

        return NotificationModel.listFromJson(jsonEncode(notificationsList));
      } else {
        throw Exception(
          'Failed to load notifications: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      rethrow;
    }
  }

  /// Mark notification as read with debug
  Future<void> markAsRead(String notificationId) async {
    final url = Uri.parse('$baseurl/api/notifications/$notificationId/read');
    print('📝 Marking notification as read: $notificationId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔹 Status Code (mark as read): ${response.statusCode}');
      print('🔹 Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to mark notification as read: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error marking as read: $e');
      rethrow;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import '../../../../services/api_services/notification_service.dart';
import '../../../Model/notification_model.dart';
import '../widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  final String token;

  const NotificationScreen({super.key, required this.token});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationService _service;
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _service = NotificationService(token: widget.token);
    _notificationsFuture = _service.getNotifications();
  }

  /// Mark a notification as read and refresh list
  Future<void> _markAsRead(String id) async {
    await _service.markAsRead(id);
    setState(() {
      _notificationsFuture = _service.getNotifications();
    });
  }

  /// Format time as `2m ago` or `1h ago`
  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  /// Shimmer effect for notifications
  Widget _notificationShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => SkeletonItem(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circle icon shimmer
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 50,
                width: 50,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            const SizedBox(width: 12),
            // Text lines shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 14,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          /// 🌌 Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff050B1E), Color(0xff393053), Color(0xff050B1E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// 📜 Notification List
          FutureBuilder<List<NotificationModel>>(
            future: _notificationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show shimmer while loading
                return _notificationShimmer();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No notifications',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                );
              }

              final notifications = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final n = notifications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NotificationCard(
                      title: n.title,
                      message: n.message,
                      time: _formatTime(n.createdAt),
                      isUnread: !n.read,
                      onTap: () => _markAsRead(n.id),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
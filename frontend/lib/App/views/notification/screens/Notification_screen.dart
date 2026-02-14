import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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
                colors: [
                  Color(0xff050B1E),
                  Color(0xff393053),
                  Color(0xff050B1E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// 📜 Notification List
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              NotificationCard(
                title: "Daily Horoscope Ready 🌙",
                message: "Your personalized horoscope for today is available.",
                time: "2m ago",
                isUnread: true,
              ),
              NotificationCard(
                title: "Love Compatibility Update 💖",
                message: "New compatibility insights have been generated for you.",
                time: "1h ago",
                isUnread: true,
              ),
              NotificationCard(
                title: "Subscription Reminder",
                message: "Your premium plan expires in 3 days.",
                time: "Yesterday",
                isUnread: false,
              ),
              NotificationCard(
                title: "Astrology Tip ✨",
                message: "Mercury retrograde begins soon. Stay mindful in communication.",
                time: "2 days ago",
                isUnread: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

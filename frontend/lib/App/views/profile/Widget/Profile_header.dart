import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String userName;
  final String email;
  final String zodiacSign;
  final String birthDate;
  final String userAvatar;

  const ProfileHeaderCard({
    super.key,
    required this.userName,
    required this.email,
    required this.zodiacSign,
    required this.birthDate,
    required this.userAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF14162E), Color(0xFF1C1F3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with white circular background
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
              boxShadow: [
                BoxShadow(
                  color: Colors.white12,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: userAvatar.isNotEmpty
                  ? (userAvatar.startsWith("http")
                  ? NetworkImage(userAvatar)
                  : AssetImage(userAvatar) as ImageProvider)
                  : null,
              child: userAvatar.isEmpty
                  ? const Icon(
                Icons.person,
                size: 50,
                color: Colors.grey,
              )
                  : null,
            ),
          ),

          const SizedBox(height: 12),

          // User Name
          Text(
            userName,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            email,
            style: GoogleFonts.dmSans(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),

          // Zodiac & Birth Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(0.4)),
                ),
                child: Text(
                  zodiacSign.toUpperCase(),
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  birthDate,
                  style: GoogleFonts.dmSans(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

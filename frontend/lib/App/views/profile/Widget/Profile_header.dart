import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String userName;
  final String email;
  final String phone;
  final String zodiacSign;
  final String userAvatar;
  final VoidCallback onAvatarTap;
  final bool isUploading;

  const ProfileHeaderCard({
    super.key,
    required this.userName,
    required this.email,
    required this.phone,
    required this.zodiacSign,
    required this.userAvatar,
    required this.onAvatarTap,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF14162E), Color(0xFF1C1F3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /// AVATAR
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.white,
                  backgroundImage: userAvatar.startsWith("http")
                      ? NetworkImage(userAvatar)
                      : null,
                  child: userAvatar.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
                if (isUploading)
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// NAME
          Text(
            userName,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          /// EMAIL
          if (email.isNotEmpty)
            Text(
              email,
              style: GoogleFonts.dmSans(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),

          const SizedBox(height: 6),

          /// PHONE
          if (phone.isNotEmpty)
            Text(
              phone,
              style: GoogleFonts.dmSans(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),

          const SizedBox(height: 12),

          /// RASHI CHIP
          if (zodiacSign.isNotEmpty)
            _infoChip(
              "Rashi: ${zodiacSign.toUpperCase()}",
              Colors.deepPurple.withOpacity(0.25),
              Colors.deepPurpleAccent.withOpacity(0.4),
            ),
        ],
      ),
    );
  }

  Widget _infoChip(String text, Color bgColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
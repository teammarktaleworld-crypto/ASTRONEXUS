import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String? userAvatar;
  final String? botAvatar;

  /// List of keywords to highlight
  final List<String> keywords;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.userAvatar,
    this.botAvatar,
    this.keywords = const [],
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.72;

    // Function to build a RichText with highlighted keywords
    TextSpan _buildTextSpan() {
      if (keywords.isEmpty) {
        return TextSpan(
          text: text,
          style: GoogleFonts.dmSans(
            color: isUser ? Colors.white : const Color(0xFF1A1A1A),
            fontSize: 15.5,
            height: 1.6,
            fontWeight: FontWeight.w400,
          ),
        );
      }

      List<TextSpan> spans = [];
      String remaining = text;

      while (remaining.isNotEmpty) {
        int index = remaining.length;
        String? matchedKeyword;

        // Find the first occurrence of any keyword
        for (var keyword in keywords) {
          final i = remaining.toLowerCase().indexOf(keyword.toLowerCase());
          if (i >= 0 && i < index) {
            index = i;
            matchedKeyword = remaining.substring(i, i + keyword.length);
          }
        }

        if (index > 0) {
          spans.add(TextSpan(
            text: remaining.substring(0, index),
            style: GoogleFonts.dmSans(
              color: isUser ? Colors.white : const Color(0xFF1A1A1A),
              fontSize: 15.5,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ));
        }

        if (matchedKeyword != null) {
          spans.add(TextSpan(
            text: matchedKeyword,
            style: GoogleFonts.dmSans(
              color: Colors.orange, // Highlight color
              fontSize: 15.5,
              height: 1.6,
              fontWeight: FontWeight.bold, // Bold
            ),
          ));
          remaining = remaining.substring(index + matchedKeyword.length);
        } else {
          remaining = '';
        }
      }

      return TextSpan(children: spans);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Bot avatar
          if (!isUser) ...[
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: botAvatar != null ? AssetImage(botAvatar!) : null,
              child: botAvatar == null
                  ? const Icon(Icons.auto_awesome, size: 16, color: Colors.deepPurple)
                  : null,
            ),
            const SizedBox(width: 8),
          ],

          // Message bubble
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                  colors: [
                    Color(0xFF00C853),
                    Color(0xFF009624),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 6),
                  bottomRight: Radius.circular(isUser ? 6 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: RichText(
                text: _buildTextSpan(),
              ),
            ),
          ),

          // User avatar
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: userAvatar != null ? NetworkImage(userAvatar!) : null,
              child: userAvatar == null
                  ? const Icon(Icons.person, size: 16, color: Colors.blueAccent)
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

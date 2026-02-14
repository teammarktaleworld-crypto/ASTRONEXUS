import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:astro_tale/ui_componets/cosmic/cosmic_one.dart';

import '../../../../services/api_services/chatbot/chat_bot_services.dart';
import '../helper/chat_suggestion.dart';
import '../widgets/chat/chat_bubble.dart';
import '../widgets/suggestion_chip.dart';

class MatiChatBotScreen extends StatefulWidget {
  const MatiChatBotScreen({super.key});

  @override
  State<MatiChatBotScreen> createState() => _MatiChatBotScreenState();
}

class _MatiChatBotScreenState extends State<MatiChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  List<String> suggestions = [];


  List<Map<String, dynamic>> messages = [];
  bool isTyping = false;

  late AnimationController planetController;

  @override
  void initState() {
    super.initState();

    planetController =
    AnimationController(vsync: this, duration: const Duration(seconds: 40))
      ..repeat();

    suggestions = ChatSuggestions.getInitialSuggestions(); // ⭐ initial suggestions


    Future.delayed(const Duration(milliseconds: 400), () {
      addBotMessage(
          "🪐 Namaste! I’m Mati, your Vedic astrology guide. Ask me about your future, career, or birth chart.");
    });
  }

  void addBotMessage(String text) {
    setState(() => messages.add({
      "text": text,
      "isUser": false,
    }));
    scrollDown();
  }

  void addUserMessage(String text) {
    setState(() => messages.add({
      "text": text,
      "isUser": true,
    }));
    scrollDown();
  }

  Future<void> sendMessage([String? suggestionText]) async {
    if (isTyping) return;

    final text = suggestionText ?? _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    _focusNode.requestFocus();
    addUserMessage(text);

    // ⭐ Update suggestions based on question
    setState(() {
      suggestions = ChatSuggestions.getSuggestionsFromQuestion(text);
      isTyping = true;
    });

    try {
      final reply = await ChatbotService.askQuestion(text);
      addBotMessage(reply);
    } catch (e) {
      addBotMessage("⚠️ Cosmic signals are weak. Please try again shortly.");
    }

    if (mounted) {
      setState(() => isTyping = false);
    }
  }


  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    planetController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: _modernAppBar(context),
      body: Stack(
        children: [
          _backgroundGradient(),
          Positioned.fill(child: SmoothShootingStars()),
          AnimatedBuilder(
              animation: planetController, builder: (_, __) => _planetField()),
          Column(
            children: [
              Expanded(child: _chatList()),

              /// ⭐ Suggestion Chips
              if (suggestions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SuggestionChips(
                    suggestions: suggestions,
                    onTap: (text) => sendMessage(text),
                  ),
                ),

              _modernInputBar(),
            ],
          ),

        ],
      ),
    );
  }

  PreferredSizeWidget _modernAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(

            child: const Icon(
              LucideIcons.arrowLeft,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 8),
          Text(
            "Mati AI",
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }


  Widget _backgroundGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff050B1E),
            // Color(0xff1C4D8D),
            // Color(0xff0F2854),
            Color(0xff393053),


            Color(0xff050B1E),

          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _chatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return const TypingIndicatorBubble();
        }

        final msg = messages[index];

        return ChatBubble(
          text: msg["text"],
          isUser: msg["isUser"],
          userAvatar: null, // add network image if available
          botAvatar: "assets/images/mati.png",
        );
      },
    );
  }

  Widget _modernInputBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => sendMessage(), // ✅ ENTER SENDS
                  style: GoogleFonts.dmSans(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Ask about your destiny...",
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
              GestureDetector(
                onTap: sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xffFFD700), Color(0xffFFB300)],
                    ),
                  ),
                  child: const Icon(LucideIcons.send,
                      size: 18, color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _planetField() {
    final t = planetController.value * 2 * pi;
    return Stack(children: [
      Positioned(
        top: 100 + sin(t) * 40,
        right: -50,
        child: Image.asset("assets/planets/planet1.png",
            height: 140, opacity: const AlwaysStoppedAnimation(.5)),
      ),
      Positioned(
        bottom: 120 + cos(t) * 30,
        left: -40,
        child: Image.asset("assets/planets/planet2.png",
            height: 110, opacity: const AlwaysStoppedAnimation(.35)),
      ),
    ]);
  }
}

class TypingIndicatorBubble extends StatelessWidget {
  const TypingIndicatorBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFEDE7F6),
            child: Icon(Icons.auto_awesome, size: 14, color: Colors.deepPurple),
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2)),
                SizedBox(width: 8),
                Text("Mati is reading your stars..."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

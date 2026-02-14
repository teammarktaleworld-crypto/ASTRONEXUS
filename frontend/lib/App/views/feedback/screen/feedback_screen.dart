import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../controller/feedback_conroller.dart';

class FeedbackScreen extends StatefulWidget {
  final String productId;

  const FeedbackScreen({Key? key, required this.productId}) : super(key: key);

  @override
  FeedbackScreenState createState() => FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen> {
  final FeedbackController _controller = FeedbackController();

  List<dynamic> feedbacks = [];
  bool loading = true;
  bool refreshing = false;

  @override
  void initState() {
    super.initState();
    loadFeedbacks();
  }

  /// Public method so parent can refresh reviews after submission
  Future<void> loadFeedbacks({bool showLoader = true}) async {
    if (showLoader && mounted) setState(() => loading = true);

    try {
      final res = await _controller.fetchFeedbacks(widget.productId);
      if (!mounted) return;

      setState(() {
        feedbacks = res;
      });
    } catch (e) {
      debugPrint('Feedback load error: $e');
      if (!mounted) return;
      setState(() => feedbacks = []);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() => refreshing = true);
    await loadFeedbacks(showLoader: false);
    if (mounted) setState(() => refreshing = false);
  }

  String _getName(dynamic item) {
    try {
      if (item is Map) {
        return item['userName'] ??
            item['user']?['name'] ??
            item['name'] ??
            'User';
      }
      return item.userName ?? item.user?.name ?? 'User';
    } catch (_) {
      return 'User';
    }
  }

  String _getComment(dynamic item) {
    try {
      if (item is Map) {
        return item['comment'] ??
            item['review'] ??
            item['description'] ??
            '';
      }
      return item.comment ?? item.review ?? item.description ?? '';
    } catch (_) {
      return '';
    }
  }

  double _getRating(dynamic item) {
    try {
      if (item is Map) return (item['rating'] as num).toDouble();
      return (item.rating as num).toDouble();
    } catch (_) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.white,
          size: 36,
        ),
      );
    }

    if (feedbacks.isEmpty) {
      return Center(
        child: Text(
          'No reviews yet',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: Colors.amberAccent,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 12),
        itemCount: feedbacks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = feedbacks[index];
          final name = _getName(item);
          final comment = _getComment(item);
          final rating = _getRating(item);

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white12,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'U',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              RatingBarIndicator(
                                rating: rating,
                                itemBuilder: (_, __) =>
                                const Icon(Icons.star, color: Colors.amber),
                                itemCount: 5,
                                itemSize: 16,
                              ),
                            ],
                          ),
                          if (comment.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              comment,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


import '../../services/api_services/feedback_api.dart';

class FeedbackController {
  final FeedbackApi _api = FeedbackApi();

  Future<List<dynamic>> fetchFeedbacks(String productId) {
    return _api.getProductFeedback(productId);
  }

  Future<void> addFeedback(String productId, double rating, String review) {
    return _api.submitFeedback(productId, rating, review);
  }
}

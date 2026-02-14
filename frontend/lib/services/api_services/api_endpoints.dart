class ApiEndpoints {
  static const String baseUrl = "https://astro-nexus-new-6.onrender.com/user";
  static const String Horoscopeurl = "https://astronexus-horoscope.onrender.com/api/horoscope?sign=leo&type=daily&day=TODAY";

  // Auth handled elsewhere
  static const String categories = "/categories";
  static const String products = "/products";

  static const String cart = "/cart";
  static const String addToCart = "/cart/add";
  static const String updateCart = "/cart/update";
  static const String removeCart = "/cart/remove";

  static const String orders = "/orders/my";
  static const String placeOrder = "/orders";

  static const String createPayment = "/payment/create";
  static const String verifyPayment = "/payment/verify";
}

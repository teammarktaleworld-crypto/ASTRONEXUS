class AstrologySignupModel {
  // Basic user info
  String name;
  String email;
  String phone;
  String password;
  String confirmPassword;

  // Birth info
  String dateOfBirth; // format: "YYYY-MM-DD"
  int hour; // 1-12
  int minute; // 0-59
  bool isAM; // true = AM, false = PM
  String place; // city, country
  double timezone; // eg: 5.5

  AstrologySignupModel({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.confirmPassword = '',
    this.dateOfBirth = '',
    this.hour = 12,
    this.minute = 0,
    this.isAM = true,
    this.place = '',
    this.timezone = 5.5,
  });

  // Convert to API-ready JSON
  Map<String, dynamic> toJson() {
    final hour24 = isAM ? hour % 12 : (hour % 12) + 12;
    final timeString =
        '${hour24.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    return {
      "name": name.trim(),
      "email": email.trim(),
      "phone": phone.trim(),
      "password": password,
      "confirmPassword": confirmPassword,
      "dateOfBirth": dateOfBirth,
      "timeOfBirth": timeString,
      "placeOfBirth": place.trim(),
    };
  }

}

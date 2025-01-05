class Discount {
  final int discountId;
  final String code;
  final String description;
  final int discountPercentage;
  final String expiryDate;

  Discount({
    required this.discountId,
    required this.code,
    required this.description,
    required this.discountPercentage,
    required this.expiryDate,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      discountId: json['discount_id'],
      code: json['code'],
      description: json['description'],
      discountPercentage: json['discount_percentage'],
      expiryDate: json['expiry_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount_id': discountId,
      'code': code,
      'description': description,
      'discount_percentage': discountPercentage,
      'expiry_date': expiryDate,
    };
  }
}

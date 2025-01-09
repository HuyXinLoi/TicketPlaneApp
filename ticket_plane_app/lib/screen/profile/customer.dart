class Customer {
  final int customerId;
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String passportNumber;
  final String address;
  final String dateOfBirth;

  Customer({
    required this.customerId,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.passportNumber,
    required this.address,
    required this.dateOfBirth,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'],
      userId: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      passportNumber: json['passport_number'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'],
    );
  }
}

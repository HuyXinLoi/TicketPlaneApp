class Flight {
  final int flightId;
  final String departureCity;
  final String arrivalCity;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String airline;
  final int price;
  final int availableSeats;

  Flight({
    required this.flightId,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.airline,
    required this.price,
    required this.availableSeats,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightId: json['flight_id'],
      departureCity: json['departure_city'],
      arrivalCity: json['arrival_city'],
      departureTime: DateTime.parse(json['departure_time']),
      arrivalTime: DateTime.parse(json['arrival_time']),
      airline: json['airline'],
      price: json['price'],
      availableSeats: json['available_seats'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flight_id': flightId,
      'departure_city': departureCity,
      'arrival_city': arrivalCity,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'airline': airline,
      'price': price,
      'available_seats': availableSeats,
    };
  }
}

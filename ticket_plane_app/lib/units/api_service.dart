import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<List<dynamic>> getDiscounts() async {
    final response = await http.get(Uri.parse('$baseUrl/discounts'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load discounts');
    }
  }

  Future<List<dynamic>> getFlights() async {
    final response = await http.get(Uri.parse('$baseUrl/flights'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load flights');
    }
  }

  Future<List<dynamic>> getPopularDestinations() async {
    final response = await http.get(Uri.parse('$baseUrl/popular_destinations'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load popular destinations');
    }
  }

  Future<List<dynamic>> getCities() async {
    final response = await http.get(Uri.parse('$baseUrl/cities'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<dynamic>> getCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<List<dynamic>> getTickets() async {
    final response = await http.get(Uri.parse('$baseUrl/tickets'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  Future<List<dynamic>> getAirlines() async {
    final response = await http.get(Uri.parse('$baseUrl/airlines'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load airlines');
    }
  }
  // Thêm các hàm get khác tương tự (getCities, getUsers, getCustomers, getTickets, ...)
}

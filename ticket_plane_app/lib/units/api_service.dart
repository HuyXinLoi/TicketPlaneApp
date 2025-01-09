import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> getCustomerById(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/customers/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load customer');
    }
  }

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

  Future<Map<String, dynamic>> addUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    if (response.statusCode == 201) {
      // Nếu server trả về status code 201 CREATED, chuyển đổi response body sang Map
      return json.decode(response.body);
    } else {
      // Nếu server trả về status code khác, throw exception với error message
      throw Exception(
          'Failed to add user: ${response.statusCode} - ${response.body}');
    }
  }
}
  // Thêm các hàm get khác tương tự (getCities, getUsers, getCustomers, getTickets, ...)


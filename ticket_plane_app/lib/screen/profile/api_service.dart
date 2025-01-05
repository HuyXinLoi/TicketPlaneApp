import 'dart:convert';
import 'package:http/http.dart' as http;
import 'customer.dart';

class ApiService {
  final String baseUrl = "https://my-json-server.typicode.com/HuyXinLoi/phongbatfulltime/customers";

  // Lấy toàn bộ danh sách khách hàng
  Future<List<Customer>> fetchCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Customer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  // Lấy thông tin khách hàng cụ thể dựa trên customerID
  Future<Customer> fetchCustomerById(int customerId) async {
    final response = await http.get(Uri.parse('$baseUrl/$customerId'));

    if (response.statusCode == 200) {
      return Customer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load customer');
    }
  }
}


import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> readJsonData(String path) async {
  final String response = await rootBundle.loadString(path);
  final data = await json.decode(response);
  return data;
}

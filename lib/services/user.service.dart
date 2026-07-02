import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:learn_flutter_nodejs/models/user.model.dart';

class UserService {
  static const baseUrl = 'http://localhost:3000/api/users';
  // static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

  static Future<Map<String, dynamic>> registerUser({
    required String fullname,
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullname,
        'email': email,
        'username': username,
        'password': password,
      }),
    );
    return jsonDecode(response.body);
  }

  static Future<List<UserModel>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    final data = jsonDecode(response.body);
    if (data['success']) {
      return (data['data'] as List).map((u) => UserModel.fromJson(u)).toList();
    }
    return [];
  }

  //update
  static Future<Map<String, dynamic>> updateUser({
    required int id,
    required String full_name,
    required String email,
    required String username,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': full_name,
        'email': email,
        'username': username,
      }),
    );
    return jsonDecode(response.body);
  }

  //detelete 

  static Future <Map <String,dynamic>> deleteUser(int id) async{
    final delete= await http.delete(Uri.parse('$baseUrl/$id'));
    return jsonDecode(delete.body);
  }
}

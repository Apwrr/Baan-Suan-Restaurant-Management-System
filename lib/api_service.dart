import 'dart:convert';
import 'package:animation_2/models/ProductItem.dart';
import 'package:animation_2/screens/home/components/category.dart';
import 'package:animation_2/screens/home/components/orders.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/Menu.dart';

class ApiService {
  final String baseUrl = "https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev";

  Future<List<Menu>> fetchMenus() async {
    final response = await http.get(Uri.parse('$baseUrl/menu-list/0'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> jsonResponse = json.decode(responseBody);
      print(jsonResponse.length);
      print('Menu ok!');
      return jsonResponse.map((menu) => Menu.fromJson(menu)).toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category-active'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(responseBody);
      print(data.length);
      print('Category ok!');
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Order> fetchOrders(int? table) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders/inprogress/$table'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        print('Orders ok!');
        print(data);
        Order orders = Order.fromJson(data);
        return orders;
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  String _errorMessage = ''; // Variable to store error messages
Future<bool> submitOrder(int? orderId, int? table, List<ProductItem> menuCart) async {
  final url = Uri.parse('$baseUrl/orders/submit');
  print('orderId: $orderId , table: $table, menuCart: $menuCart');
  print('Orders ID!');
  final headers = {"Content-Type": "application/json"};
  final List<Map<String, dynamic>> orderItems = menuCart.map((item) {
    return {
      'menuId': item.menu.id,
      'price': item.menu.price,
      'quantity': item.quantity,
      'remark': item.remark,
    };
  }).toList();

  final body = json.encode({
    'orderId': 0,
    'table': table,
    'orderItems': orderItems,
  });
  print('Request payload: $body');

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Order submitted successfully');
      return true;
    } else {
      final decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      final Map<String, dynamic> errorResponse = jsonDecode(decodedResponse);
      _errorMessage = _formatErrorMessage(errorResponse['message'] ?? 'Unknown error');
      print('Failed to submit order: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    _errorMessage = 'Failed to submit order: $e';
    print(_errorMessage);
    return false; // Ensure false is returned in case of an exception
  }
}

// Method to format error messages for better readability
String _formatErrorMessage(String message) {
  // Format the message to add line breaks after certain keywords
  String replace = message.replaceAll('Ingredient', '\nIngredient');
  replace = replace.replaceAll('available', '\navailable');
  return replace;
}

String getErrorMessage() => _errorMessage;

  String _errorMessageValidateOrder = ''; // Variable to store error messages
  Future<bool> validateOrder(int? orderId, int? table, List<ProductItem> menuCart) async {
    final url = Uri.parse('https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/orders/validateOrder');
    print('orderId: $orderId , table: $table, menuCart: $menuCart');
    print('Orders ID!');
    final headers = {"Content-Type": "application/json"};
    final List<Map<String, dynamic>> orderItems = menuCart.map((item) {
      return {
        'menuId': item.menu.id,
        'price': item.menu.price,
        'quantity': item.quantity,
        'remark': item.remark,
      };
    }).toList();

    final body = json.encode({
      'orderId': orderId,
      'table': table,
      'orderItems': orderItems,
    });
    print('Request payload: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Order validateOrder successfully');
        return true;
      } else {
        final decodedResponse = utf8.decode(response.bodyBytes);
        print(decodedResponse);
        final Map<String, dynamic> errorResponse = jsonDecode(decodedResponse);
        _errorMessageValidateOrder = _formatErrorMessage(errorResponse['message'] ?? 'Unknown error');
        print('Failed to validate Order: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      _errorMessageValidateOrder = 'Failed to validate Order: $e';
      print(_errorMessageValidateOrder);
      return false; // Ensure false is returned in case of an exception
    }
  }

// Method to format error messages for better readability
  String formatErrorMessage(String message) {
    // Format the message to add line breaks after certain keywords
    String replace = message.replaceAll('Ingredient', '\nIngredient');
    replace = replace.replaceAll('available', '\navailable');
    return replace;
  }

  String getValidateErrorMessage() => _errorMessageValidateOrder;
}

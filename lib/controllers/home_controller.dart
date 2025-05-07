import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animation_2/screens/home/components/orders.dart';
import 'package:animation_2/models/Menu.dart';
import 'package:animation_2/models/ProductItem.dart';
import 'package:animation_2/api_service.dart';

enum HomeState {
  normal,
  cart,
}

class HomeController extends ChangeNotifier {
  HomeState _homeState = HomeState.normal;
  List<ProductItem> _menuCart = [];
  Order orders = Order(
    id: 0,
    table: 0,
    orderNo: '',
    status: '',
    orderItemDtoList: [],
  );

  final ApiService _apiService = ApiService();
  Timer? _orderRefreshTimer;

  HomeState get homeState => _homeState;

  List<ProductItem> get menuCart => _menuCart;

  Order get orderItems => orders;

  void changeHomeState(HomeState state) {
    _homeState = state;
    notifyListeners();
  }

  void addProductToCart(Menu menu, int quantity, String remark) {
    for (var item in _menuCart) {
      if (item.menu == menu && item.remark == remark) {
        item.quantity += quantity;
        notifyListeners();
        return;
      }
    }
    _menuCart.add(ProductItem(menu: menu, quantity: quantity, remark: remark));
    notifyListeners();
  }

  void updateProductQuantity(ProductItem product, int quantity) {
    int index = _menuCart.indexWhere((item) => item.menu.id == product.menu.id);
    if (index != -1) {
      _menuCart[index].quantity = quantity;
    }
    notifyListeners();
  }

  void incrementItem(ProductItem item) {
    item.increment();
    notifyListeners();
  }

  void decrementItem(ProductItem item) {
    item.decrement();
    if (item.quantity <= 0) {
      _menuCart.remove(item);
    }
    notifyListeners();
  }

  void removeProductFromCart(ProductItem product) {
    _menuCart.removeWhere((item) => item.menu.id == product.menu.id);
    notifyListeners();
  }

  void moveCartToOrder() {
    _menuCart.clear();
    notifyListeners();
  }

  int totalCartItems() {
    int total = 0;
    for (var item in _menuCart) {
      total += item.quantity;
    }
    return total;
  }

  Future<void> fetchOrders(int table) async {
    try {
      orders = await _apiService.fetchOrders(table);
      notifyListeners();
    } catch (e) {
      print('Failed to fetch orders: $e');
    }
  }

  // Method to update orderId without resetting
  void updateOrderId(int id) {
    if (orders.id == 0) {
      orders.id = id;
      notifyListeners();
    }
  }

  // Method to refresh orders periodically
  void startOrderRefresh(int table) {
    stopOrderRefresh(); // Ensure any existing timer is cancelled
    _orderRefreshTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await fetchOrders(table);
    });
  }

  // Method to stop the periodic refresh
  void stopOrderRefresh() {
    _orderRefreshTimer?.cancel();
  }

  @override
  void dispose() {
    stopOrderRefresh();
    super.dispose();
  }
  String getErrorMessage() => _apiService.getErrorMessage();
  String getErrorMessageValidate() => _apiService.getValidateErrorMessage();


}

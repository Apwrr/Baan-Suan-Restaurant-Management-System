import 'package:animation_2/api_service.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/components/price.dart';
import 'package:animation_2/screens/deatils/components/cart_counter.dart';
import '../../../models/ProductItem.dart';

// ignore: camel_case_types
class Order_UserDetails extends StatefulWidget {
  const Order_UserDetails({
    Key? key,
    required this.productItem,
    required this.controller,
    required this.onRemove,
    required this.table,
  }) : super(key: key);

  final ProductItem productItem;
  final HomeController controller;
  final VoidCallback onRemove;
  final int? table;

  @override
  _Order_UserDetailsState createState() => _Order_UserDetailsState();
}

class _Order_UserDetailsState extends State<Order_UserDetails> {
  final ApiService _apiService = ApiService();
  late int _quantity;
  late TextEditingController _remarkController;

  @override
  void initState() {
    super.initState();
    _quantity = widget.productItem.quantity;
    _remarkController = TextEditingController(text: widget.productItem.remark);
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  void _incrementQuantity() async {
    // ตรวจสอบ orderId และ table (เปลี่ยนเป็นค่าที่คุณใช้งานจริง)
    int? table = widget.table;
    int nextQuantity = _quantity + 1;
    // เตรียมรายการ menuCart เพื่อส่งไปตรวจสอบ
    List<ProductItem> menuCart = [
      ProductItem(
        menu: widget.productItem.menu,
        quantity: nextQuantity, // กำหนดจำนวนเป็นจำนวนถัดไป
        remark: widget.productItem.remark,
      ),
    ];
    // เรียกใช้ validateOrder
    bool success = await _apiService.validateOrder(widget.controller.orders.id, widget.table, menuCart);
    if (success) {
      // ถ้า validate ผ่าน เพิ่มจำนวนสินค้า
      setState(() {
        _quantity++;
      });
      widget.controller.updateProductQuantity(widget.productItem, _quantity);
    } else {
      // ถ้า validate ไม่ผ่าน แสดง error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('วัตถุดิบเพียงพอสำหรับ'),
            content: Text('${_apiService.getValidateErrorMessage()} เท่านั้น'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด dialog
                },
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
      widget.controller.updateProductQuantity(widget.productItem, _quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(widget.productItem.menu.imagePath!),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.productItem.menu.nameTh!,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: _remarkController,
            decoration: InputDecoration(
              labelText: 'เพิ่มเติม',
            ),
            onChanged: (value) {
              widget.productItem.remark = value; // อัปเดต remark ใน productItem
            },
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Row(
              children: [
                Price(amount: widget.productItem.menu.price!),
                SizedBox(width: 10),
                CartCounter(
                  quantity: _quantity,
                  onIncrement: _incrementQuantity,
                  onDecrement: _decrementQuantity,
                  buttonSize: 30.0, // กำหนดขนาดปุ่มใน Order_UserDetails
                  iconSize: 16.0, // กำหนดขนาดไอคอนใน Order_UserDetails
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              widget.controller.removeProductFromCart(widget.productItem);
              widget.onRemove();
            },
          ),
        ],
      ),
    );
  }
}
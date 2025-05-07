import 'package:animation_2/screens/home/components/order_UserDetails.dart';
import 'package:flutter/material.dart';
import 'package:animation_2/constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/screens/home/components/order_status.dart';
import 'package:animation_2/api_service.dart';

class Order_User extends StatefulWidget {
  const Order_User({Key? key, required this.controller, required this.table}) : super(key: key);

  final HomeController controller;
  final int? table;

  @override
  _Order_UserState createState() => _Order_UserState();
}

class _Order_UserState extends State<Order_User> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFE4F0E6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "รายการอาหาร",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          SizedBox(width: defaultPadding),
        ],
      ),
      body: Stack(
        children: [
          widget.controller.menuCart.isEmpty
              ? Center(
            child: Text(
              'ไม่มีรายการสั่งอาหาร',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          )
              : ListView(
            padding: EdgeInsets.only(bottom: 60),
            children: List.generate(
              widget.controller.menuCart.length,
                  (index) => Order_UserDetails(
                productItem: widget.controller.menuCart[index],
                controller: widget.controller,
                table: widget.table,
                onRemove: () {
                  setState(() {}); // Update the state when item is removed
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.controller.menuCart.isEmpty
                      ? null
                      : () async {
                    try {
                      // รอการทำงานของ submitOrder และรับค่าผลลัพธ์
                      bool success = await _apiService.submitOrder(
                          widget.controller.orders.id, widget.table, widget.controller.menuCart);

                      // ตรวจสอบว่าการทำงานสำเร็จหรือไม่
                      if (success) {
                        print(widget.controller.orders.id);
                        widget.controller.moveCartToOrder();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('สั่งอาหารสำเร็จ'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderStatus(
                              controller: widget.controller,
                              table: widget.table,
                            ),
                          ),
                        );
                      } else {
                        // แสดง AlertDialog เมื่อเกิดข้อผิดพลาด
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('วัตถุดิบไม่เพียงพอสำหรับ'),
                              content: Text(_apiService.getErrorMessage()),
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
                    } catch (e) {
                      print('Failed to submit order: $e'); // Handle error
                    }
                  },


                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE4F0E6),
                  ),
                  child: Text(
                    "สั่งอาหาร",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

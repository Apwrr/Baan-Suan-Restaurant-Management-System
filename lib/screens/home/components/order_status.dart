import 'package:animation_2/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:animation_2/constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/models/ProductItem.dart';
import 'order_statusDetails.dart'; // Import your Order_statusDetails widget

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key, required this.controller, required this.table}) : super(key: key);

  final HomeController controller;
  final int? table;

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    await widget.controller.fetchOrders(widget.table!);
    setState(() {
      _isFirstLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xFFE4F0E6),
        ),
        backgroundColor: Color(0xFFE4F0E6),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "สถานะรายการอาหาร",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _isFirstLoad
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchOrders,
        child: Stack(
          children: [
            if (widget.controller.orderItems.orderItemDtoList.isEmpty)
              Center(
                child: Text(
                  'ไม่มีรายการสั่งอาหาร',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            else
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: List.generate(
                    widget.controller.orderItems.orderItemDtoList.length,
                        (index) => Order_statusDetails(
                      orderItem: widget.controller.orderItems.orderItemDtoList[index],
                      controller: widget.controller,
                    ),
                  ).toList(),
                ),
              ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            controller: widget.controller,
                            table: widget.table,
                            orderId: widget.controller.orderItems.id,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFE4F0E6), // สีปุ่ม
                    ),
                    child: Text(
                      "กลับไปหน้าเมนู",
                      style: TextStyle(color: Colors.black), // สีตัวหนังสือ
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

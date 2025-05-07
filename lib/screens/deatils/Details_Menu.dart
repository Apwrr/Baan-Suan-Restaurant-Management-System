import 'package:animation_2/api_service.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/models/ProductItem.dart';
import 'package:flutter/material.dart';
import 'package:animation_2/components/price.dart';
import 'package:animation_2/constants.dart';
import 'package:animation_2/models/Menu.dart';
import 'components/cart_counter.dart';
import 'package:http/http.dart' as http;

class Details_Menu extends StatefulWidget {
  const Details_Menu({
    Key? key,
    required this.menu,
    required this.onProductAdd,
    required this.controller,
    this.table,
  }) : super(key: key);

  final Menu menu;
  final Function(int, String) onProductAdd;
  final HomeController controller;
  final int? table;

  @override
  _Details_MenuState createState() => _Details_MenuState();
}

class _Details_MenuState extends State<Details_Menu> {
  final ApiService _apiService = ApiService();
  String _cartAdd = "";
  int quantity = 1; // จำนวนสินค้าเริ่มต้น
  int maxQty = 0; // เก็บจำนวนสูงสุดที่ได้จาก API
  TextEditingController remark = TextEditingController();

  @override
  void initState() {
    super.initState();

    // แสดง id ของเมนูในคอนโซล
    print('Menu ID: ${widget.menu.id}');
    if (widget.menu.id != null) {
      checkAvailableQty(widget.menu.id!); // ตรวจสอบจำนวนที่มีอยู่ก่อน
    } else {
      print('Menu ID is null');
    }
  }

  Future<void> checkAvailableQty(int id) async {
    final url = 'https://204rylujk7.execute-api.ap-southeast-2.amazonaws.com/dev/menu/checkAvailableQty/$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Available quantity data: ${response.body}');
        setState(() {
          maxQty = int.parse(response.body); // กำหนดค่า maxQty จาก response.body
        });
      } else {
        print('Failed to fetch available quantity: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching available quantity: $e');
    }
  }

  void increment() async {
    if (quantity < maxQty) {
      // ตรวจสอบก่อนว่าจำนวนที่เพิ่มยังไม่เกิน maxQty
      setState(() {
        quantity++;
      });
    } else {
      // แสดง AlertDialog เมื่อเกิดข้อผิดพลาด
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ขออภัย'),
            content: Text('จำนวนที่เพิ่มสูงสุดแล้ว'),
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

  void decrement() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 1.37,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              color: Color(0xFFF8F8F8),
                              child: Hero(
                                tag: widget.menu.nameTh ?? 'defaultTag' + _cartAdd,
                                child: Image.asset(widget.menu.imagePath ?? 'assets/images/default.png'),
                              ),
                            ),
                            Positioned(
                              bottom: -20,
                              child: CartCounter(
                                onIncrement: increment,
                                onDecrement: decrement,
                                quantity: quantity,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: defaultPadding * 1.5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.menu.nameTh ?? 'ชื่อเมนู',
                                style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Price(amount: widget.menu.price ?? 0),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: remark,
                            decoration: InputDecoration(
                              hintText: 'ช่องเขียนเพิ่มเติม',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: defaultPadding), // ระยะห่างเพิ่มเติม
                    ],
                  ),
                ),
              ),
            ],
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
                  onPressed: () async {
                    bool success = await _apiService.validateOrder(
                      widget.controller.orders.id,
                      widget.controller.orders.table,
                      [
                        ProductItem(
                          menu: widget.menu,
                          quantity: quantity,
                          remark: remark.text,
                        )
                      ],
                    );

                    if (success) {
                      widget.onProductAdd(quantity, remark.text);
                      setState(() {
                        _cartAdd = '_cartAdd';
                      });
                      Navigator.pop(context);
                    } else {
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
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE4F0E6), // กำหนดสีปุ่มเป็น E4F0E6
                  ),
                  child: Text(
                    "เพิ่มลงตะกร้า",
                    style: TextStyle(color: Colors.black), // กำหนดสีตัวหนังสือในปุ่มเป็นสีดำ
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(
        color: Colors.black,
      ),
      backgroundColor: Color(0xFFE4F0E6), // กำหนดสีของ AppBar เป็น E4F0E6
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Food",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

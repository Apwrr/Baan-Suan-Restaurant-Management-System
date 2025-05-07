import 'package:animation_2/screens/home/components/category.dart';
import 'package:flutter/material.dart';
import 'package:animation_2/api_service.dart'; // Import ApiService
import '../../../constants.dart';



class HomeHeader extends StatefulWidget {
  final Function(int) onCategorySelected;
  final int? table;

  const HomeHeader({
    Key? key,
    required this.onCategorySelected,  this.table,
  }) : super(key: key);

  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int selectedCategory = 0; // กำหนดหมวดหมู่เริ่มต้น
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      List<Category> fetchedCategories = await ApiService().fetchCategories();
      setState(() {
        categories = fetchedCategories;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: headerHeight,
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Color(0xFFE4F0E6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ร้านอาหาร บ้านสวน",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "รายการอาหาร",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.black54),
                  )
                ],
              ),
              Text(
                "โต๊ะ ${widget.table ?? 'ไม่ระบุ'}", // แสดงค่า table หรือ 'ไม่ระบุ' ถ้า table เป็น null
                style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.black54),
              )
            ],
          ),
          SizedBox(height: 8),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: categories.map((category) {
                return _buildCategory(context, category.nameTh, category.number);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String title, int cat) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = cat;
          print(cat);
        });
        widget.onCategorySelected(cat);
      },
      child: Container(
        margin: EdgeInsets.only(right: 8), // เพิ่ม margin ระหว่างหมวดอาหาร
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedCategory == cat ? Colors.orange[300] : Colors.grey[100], // เปลี่ยนสีตามหมวดที่เลือก
        ),
        child: Text(
          title,
          style: TextStyle(
            color: selectedCategory == cat ? Colors.black : Colors.black,
          ),
        ),
      ),
    );
  }
}

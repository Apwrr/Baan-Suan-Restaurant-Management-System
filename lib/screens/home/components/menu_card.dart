import 'package:animation_2/components/price.dart';
import 'package:animation_2/models/Menu.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    Key? key,
    required this.menu,
    required this.press,
  }) : super(key: key);

  final Menu menu;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: menu.isActive ? press : null, // ถ้า isActive เป็น false จะไม่สามารถกดได้
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: menu.isActive ? Color(0xFFF7F7F7) : Colors.grey.shade400, // เปลี่ยนสีเป็นสีเทาถ้า isActive เป็น false
          borderRadius: const BorderRadius.all(
            Radius.circular(defaultPadding * 1.25),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (menu.imagePath != null)
                  Hero(
                    tag: menu.nameTh ?? 'defaultTag',
                    child: Image.asset(menu.imagePath!),
                  ),
                if (menu.nameTh != null)
                  Text(
                    menu.nameTh!,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                if (menu.price != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Price(amount: menu.price!),
                      //FavBtn(),
                    ],
                  ),
              ],
            ),
            if (!menu.isActive)
              Container(
                color: Colors.grey.shade400.withOpacity(0.5), // สีเทาเข้มกว่าด้านหลัง
                child: Center(
                  child: Text(
                    'หมด',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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


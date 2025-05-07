import 'package:animation_2/screens/home/components/orders.dart';
import 'package:flutter/material.dart';
import 'package:animation_2/constants.dart';
import 'package:animation_2/controllers/home_controller.dart';
import 'package:animation_2/models/ProductItem.dart';

class Order_statusDetails extends StatelessWidget {
  final OrderItem orderItem;
  final HomeController controller;

  const Order_statusDetails({
    Key? key,
    required this.orderItem,
    required this.controller,
  }) : super(key: key);

  String getStatusText(String status) {
    switch (status) {
      case 'PREPARING':
        return 'กำลังเตรียม';
      case 'COOKING':
        return 'กำลังทำ';
      case 'COMPLETED':
        return 'สำเร็จ';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(orderItem.imagePath),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orderItem.menuName,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            " x ${orderItem.qty}",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          if (orderItem.remark.isNotEmpty)
            Text(
              ' เพิ่มเติม : ${orderItem.remark}',
              style: Theme.of(context).textTheme.subtitle2,
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Row(
              children: [
                Text(
                  " : ${getStatusText(orderItem.status)}",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

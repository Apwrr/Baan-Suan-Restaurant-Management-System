class Order {
  int id;
  final int? table;
  final String orderNo;
  final String status;
  final List<OrderItem> orderItemDtoList;

  Order({
    required this.id,
    required this.table,
    required this.orderNo,
    required this.status,
    required this.orderItemDtoList,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem> orderItems = [];
    if (json['orderItemDtoList'] != null) {
      orderItems = List<OrderItem>.from(json['orderItemDtoList'].map((item) => OrderItem.fromJson(item)));
    }
    return Order(
      id: json['id'] ?? Null, // Provide default value or handle null case
      table: json['table'],
      orderNo: json['orderNo'] ?? '',
      status: json['status'] ?? '',
      orderItemDtoList: orderItems,
    );
  }
  }

class OrderItem {
  final int id;
  final int menuId;
  final String imagePath;
  final String menuName;
  final double price;
  final int qty;
  final String remark;
  final String status;

  OrderItem({
    required this.id,
    required this.menuId,
    required this.imagePath,
    required this.menuName,
    required this.price,
    required this.qty,
    required this.remark,
    required this.status,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0, // Provide default value or handle null case
      menuId: json['menuId'] ?? 0,
      imagePath: json['imagePath'] ?? '',
      menuName: json['menuName'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      qty: json['qty'] ?? 0,
      remark: json['remark'] ?? '',
      status: json['status'] ?? '',
    );
  }
}



import 'package:animation_2/screens/home/components/order_user.dart';
import 'package:animation_2/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'controllers/home_controller.dart';

void main() {
  HomeController controller = HomeController();
  int? table = int.tryParse(Uri.base.queryParameters['table'] ?? '0');
  runApp(MyApp(controller: controller, table: table));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.controller, required this.table, this.orderId}) : super(key: key);

  final HomeController controller;
  final int? table;
  final int? orderId;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            shape: StadiumBorder(),
            backgroundColor: primaryColor,
          ),
        ),
      ),
      home: HomeScreen(table: table, controller: controller,orderId: orderId),
    );
  }
}

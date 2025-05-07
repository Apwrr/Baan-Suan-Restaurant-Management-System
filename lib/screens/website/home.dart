import 'package:flutter/material.dart';

class Website extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'D a s h b o r d',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Color(0xFFD0E2D3), // เปลี่ยนสีของ AppBar
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black), // เปลี่ยนสีไอคอนเป็นสีดำ
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFD0E2D3),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.note_add),
              title: Text('บันทึกค่าใช้จ่าย'),
              onTap: () {
                // ใส่ฟังก์ชันที่ต้องการเมื่อเลือกเมนูนี้
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('สรุปยอด'),
              onTap: () {
                // ใส่ฟังก์ชันที่ต้องการเมื่อเลือกเมนูนี้
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('สรุป'),
              onTap: () {
                // ใส่ฟังก์ชันที่ต้องการเมื่อเลือกเมนูนี้
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(),
    );
  }
}

void main() => runApp(MaterialApp(
  home: Website(),
));

import 'package:dream/pages/notice/notice_body_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dream App"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black87,
        unselectedItemColor: Colors.black26,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        //TODO: 다른 메뉴들 넣어야함.
        items: [
          BottomNavigationBarItem(label: "공지사항", icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(label: "공지사항2", icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(label: "공지사항3", icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(label: "공지사항4", icon: Icon(Icons.favorite)),
        ],
      ),
      body: Center(
        child: _widgetList.elementAt(_selectedIndex),
      ),
    );
  }

  List _widgetList = [
    NoticeBodyWidget(),
    Text("공지사항2"),
    Text("공지사항3"),
    Text("공지사항4"),
  ];
}

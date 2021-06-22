import 'package:dream/app/core/constants/constants.dart';
import 'package:dream/app/pages/common/profile_app_bar.dart';
import 'package:dream/app/pages/notice/notice_body_screen.dart';
import 'package:dream/app/pages/pray/pray_list_screen.dart';
import 'package:dream/app/pages/pray/pray_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<String> _titleList = ['공지사항', '기도 보내기', '중보 기도'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProfileAppBar(
          title: _titleList[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Constants.backgroundColor,
          selectedItemColor: Constants.iconSelectedColor,
          unselectedItemColor: Constants.iconColor,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          //TODO: 다른 메뉴들 넣어야함.
          items: [
            BottomNavigationBarItem(label: "공지사항", icon: Icon(Icons.favorite)),
            BottomNavigationBarItem(
                label: "기도 보내기", icon: Icon(Icons.favorite)),
            BottomNavigationBarItem(label: "중보 기도", icon: Icon(Icons.favorite)),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _bodyWidgetList,
        ));
  }

  //바텀 네비게이션바에 연결된 BodyWidget들
  List<Widget> _bodyWidgetList = [
    NoticeBodyScreen(),
    PrayScreen(),
    PrayListScreen(),
  ];
}

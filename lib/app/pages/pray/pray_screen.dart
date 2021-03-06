import 'package:dream/app/core/constants/constants.dart';
import 'package:dream/app/pages/common/profile_app_bar.dart';
import 'package:dream/app/pages/pray/pray_send_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class PrayScreen extends StatelessWidget {
  void pageToSendPrayScreen(bool isPublic) {
    Get.toNamed(PraySendScreen.routeName, arguments: isPublic);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => pageToSendPrayScreen(true),
                child: Container(
                  width: size.width * 0.8,
                  height: 150.h,
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.send,
                            size: 35,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "?????? ?????? ??????",
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wb_incandescent_sharp,
                            color: Constants.iconColor,
                          ),
                          Text(
                            '???????????? ???????????? ??????????????? ????????????.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              GestureDetector(
                onTap: () => pageToSendPrayScreen(false),
                child: Container(
                  width: size.width * 0.8,
                  height: 150.h,
                  decoration: BoxDecoration(
                      color: Constants.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.send,
                            size: 35,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text("?????? ?????? ??????",
                              style: TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wb_incandescent_sharp,
                            color: Constants.iconColor,
                          ),
                          Text(
                            '?????????????????? ???????????? ??????????????? ????????????.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

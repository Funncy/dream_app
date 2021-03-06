import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottonInputBar extends StatelessWidget {
  const BottonInputBar({
    Key? key,
    required this.textEditingController,
    required this.writeFunction,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final Function writeFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      color: Colors.white,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Container(
              width: 300.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력해주세요 :)',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(9),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.amber),
            child: InkWell(
                onTap: writeFunction as void Function()?,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}

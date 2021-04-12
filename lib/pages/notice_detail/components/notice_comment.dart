import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeComment extends StatelessWidget {
  const NoticeComment({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60.w,
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/test-img.jpeg'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "유저 아이디",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('더드림/시온/두드림 . 25분전'),
                          ),
                        ],
                      ),
                    ),
                    InkWell(child: Icon(Icons.more_vert))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: 230.w,
                    child: Text(
                      "본문 ~~~~ ~~~ \n ~~~~~~~~~~~~~~~ \n ~~~~~~~~~~~~~~ asdjaskdljaslkdjalksjdlkasjdlkjaslkdjaslkjdlkasjdlkjasldkjaslkdjlaksjdlkasjdlkasjdlkajsdlkjaslkdjaslkdjlaksjdlkasjdlkj",
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      child: Text(
                        "공감하기",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Text(
                        "답글쓰기",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
